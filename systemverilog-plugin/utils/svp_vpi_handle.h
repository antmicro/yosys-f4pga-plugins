#ifndef SYSTEMVERILOG_PLUGIN_UTILS_SVP_VPI_HANDLE
#define SYSTEMVERILOG_PLUGIN_UTILS_SVP_VPI_HANDLE

#include <uhdm/BaseClass.h>
#include <uhdm/vpi_uhdm.h>
#include <uhdm/vpi_user.h>

#include <cstdint>
#include <string_view>

namespace systemverilog_plugin
{

namespace internal
{
class SvpVpiHandleIterableRelation;
}
class SvpVpiHandle;
class SvpVpiHandleRef;

////////////////////////////////////////////////////////////////////////
// DECLARATIONS
////////////////////////////////////////////////////////////////////////

namespace internal
{

class SvpVpiHandleBase
{
  protected:
    vpiHandle handle = vpiHandle{};

    // Initialize

    SvpVpiHandleBase() = default;

    explicit SvpVpiHandleBase(vpiHandle h) : handle(h) {}

    // Copy

    SvpVpiHandleBase(const SvpVpiHandleBase &) = default;

    SvpVpiHandleBase &operator=(const SvpVpiHandleBase &) = default;

    // Move

    SvpVpiHandleBase(SvpVpiHandleBase &&other) = default;

    SvpVpiHandleBase &operator=(SvpVpiHandleBase &&other) = default;

    // Destroy

    ~SvpVpiHandleBase() = default;

  public:
    // Operators and data access

    operator bool() const { return handle != vpiHandle{}; }

    friend bool operator==(const SvpVpiHandleBase &l, const SvpVpiHandleBase &r) { return l.handle == r.handle; }

    vpiHandle operator*() const { return handle; }

    const UHDM::BaseClass *uhdm_object() const;

    // VPI operations: properties

    std::int32_t get_int(std::int32_t prop) const { return vpi_get(prop, handle); }

    const char *get_str(std::int32_t prop) const { return vpi_get_str(prop, handle); }

    std::string_view get_str(std::int32_t prop, std::string_view def) const;

    s_vpi_value get_value() const;

    // VPI operations: relations

    SvpVpiHandle relation(std::int32_t type) const;

    internal::SvpVpiHandleIterableRelation iterate_relation(std::int32_t type) const;
};

} // namespace internal

// VPI handle.
class SvpVpiHandle final : public internal::SvpVpiHandleBase
{
  private:
    void release_handle();

  public:
    // Initialize

    SvpVpiHandle() : SvpVpiHandleBase() {}

    explicit SvpVpiHandle(vpiHandle h) : SvpVpiHandleBase(h) {}

    explicit SvpVpiHandle(const UHDM::BaseClass *obj) : SvpVpiHandleBase(obj ? NewVpiHandle(obj) : vpiHandle{}) {}

    // Copy

    SvpVpiHandle(const SvpVpiHandle &) = delete;

    SvpVpiHandle &operator=(const SvpVpiHandle &) = delete;

    // Move

    SvpVpiHandle(SvpVpiHandle &&other) : SvpVpiHandleBase(other.handle) { other.handle = vpiHandle{}; }

    SvpVpiHandle &operator=(SvpVpiHandle &&other);

    // Destroy

    ~SvpVpiHandle() { release_handle(); }

    // Operators

    operator SvpVpiHandleRef() const;
};

class SvpVpiHandleRef final : public internal::SvpVpiHandleBase
{
  public:
    // Initialize

    SvpVpiHandleRef() : SvpVpiHandleBase() {}

    explicit SvpVpiHandleRef(vpiHandle h) : SvpVpiHandleBase(h) {}

    // Copy

    SvpVpiHandleRef(const SvpVpiHandleRef &other) = default;

    SvpVpiHandleRef &operator=(const SvpVpiHandleRef &other) = default;

    // Move

    SvpVpiHandleRef(SvpVpiHandleRef &&other) = default;

    SvpVpiHandleRef &operator=(SvpVpiHandleRef &&other) = default;

    // Destroy

    ~SvpVpiHandleRef() = default;
};

// Makes new, independent SvpVpiHandle instance referring to the same UHDM object as passed `handle`.
inline SvpVpiHandle clone(SvpVpiHandleRef handle) { return handle ? SvpVpiHandle(handle.uhdm_object()) : SvpVpiHandle(); }

namespace internal
{

class SvpVpiHandleIterableRelation
{
    SvpVpiHandle iterator_handle = SvpVpiHandle();

  public:
    class Iterator
    {
        SvpVpiHandleRef iterator_handle = SvpVpiHandleRef();
        SvpVpiHandle handle = SvpVpiHandle();

        Iterator(SvpVpiHandleRef ih, SvpVpiHandle &&h) : iterator_handle(ih), handle(std::move(h)) {}

      public:
        // Initialize

        Iterator() = default;

        Iterator(SvpVpiHandleRef ih) : iterator_handle(ih), handle(SvpVpiHandle(vpi_scan(*iterator_handle))) {}

        // Copy

        Iterator(const Iterator &) = delete;

        Iterator &operator=(const Iterator &) = delete;

        // Move

        Iterator(Iterator &&other) : iterator_handle(other.iterator_handle), handle(std::move(other.handle)) {}

        Iterator &operator=(Iterator &&other);

        // Destroy

        ~Iterator() = default;

        // Operators

        operator bool() const { return !!handle; }

        friend bool operator==(const Iterator &l, const Iterator &r) { return l.handle == r.handle; }

        const SvpVpiHandle &operator*() { return handle; }

        Iterator &operator++();
    };

    // Initialize

    SvpVpiHandleIterableRelation() = delete;

    explicit SvpVpiHandleIterableRelation(vpiHandle h) : iterator_handle(h){};

    // Copy

    SvpVpiHandleIterableRelation(const SvpVpiHandleIterableRelation &) = delete;

    SvpVpiHandleIterableRelation &operator=(const SvpVpiHandleIterableRelation &) = delete;

    // Move

    SvpVpiHandleIterableRelation(SvpVpiHandleIterableRelation &&) = default;

    SvpVpiHandleIterableRelation &operator=(SvpVpiHandleIterableRelation &&) = delete;

    // Destroy

    ~SvpVpiHandleIterableRelation() = default;

    // Iteration

    Iterator begin() { return Iterator(iterator_handle); }

    Iterator end() { return Iterator(); }
};

} // namespace internal

////////////////////////////////////////////////////////////////////////
// INLINE DEFINITIONS
////////////////////////////////////////////////////////////////////////

inline const UHDM::BaseClass *internal::SvpVpiHandleBase::uhdm_object() const
{
    if (handle == vpiHandle{}) {
        return nullptr;
    }
    const uhdm_handle *const uhdm_h = reinterpret_cast<uhdm_handle *>(handle);
    return reinterpret_cast<const UHDM::BaseClass *>(uhdm_h->object);
}

inline std::string_view internal::SvpVpiHandleBase::get_str(std::int32_t prop, std::string_view def) const
{
    if (const char *s = vpi_get_str(prop, handle)) {
        return s;
    }
    return def;
}

inline s_vpi_value internal::SvpVpiHandleBase::get_value() const
{
    s_vpi_value result;
    vpi_get_value(handle, &result);
    return result;
}

inline SvpVpiHandle internal::SvpVpiHandleBase::relation(std::int32_t type) const { return SvpVpiHandle(vpi_handle(type, handle)); }

inline internal::SvpVpiHandleIterableRelation internal::SvpVpiHandleBase::iterate_relation(std::int32_t type) const
{
    return internal::SvpVpiHandleIterableRelation(vpi_iterate(type, handle));
}

inline void SvpVpiHandle::release_handle()
{
    vpi_release_handle(handle);
    handle = vpiHandle{};
}

inline SvpVpiHandle &SvpVpiHandle::operator=(SvpVpiHandle &&other)
{
    release_handle();
    handle = other.handle;
    other.handle = vpiHandle{};
    return *this;
}

inline SvpVpiHandle::operator SvpVpiHandleRef() const { return SvpVpiHandleRef(handle); }

inline internal::SvpVpiHandleIterableRelation::Iterator &internal::SvpVpiHandleIterableRelation::Iterator::operator=(Iterator &&other)
{
    iterator_handle = other.iterator_handle;
    handle = std::move(other.handle);
    return *this;
}

inline internal::SvpVpiHandleIterableRelation::Iterator &internal::SvpVpiHandleIterableRelation::Iterator::operator++()
{
    handle = SvpVpiHandle(vpi_scan(*iterator_handle));
    return *this;
}

////////////////////////////////////////////////////////////////////////

} // namespace systemverilog_plugin

#endif // SYSTEMVERILOG_PLUGIN_UTILS_SVP_VPI_HANDLE
