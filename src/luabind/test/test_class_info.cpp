// Copyright Daniel Wallin 2009. Use, modification and distribution is
// subject to the Boost Software License, Version 1.0. (See accompanying
// file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

#include "test.hpp"
#include <luabind/class_info.hpp>
#include <luabind/luabind.hpp>

struct X
{
    void f()
    {}

    int x;
    int y;
};

void test_main(lua_State* L)
{
    using namespace luabind;

    bind_class_info(L);

    module(L) [
        class_<X>("X")
            .def(constructor<>())
            .def("f", &X::f)
            .def_readonly("x", &X::x)
            .def_readonly("y", &X::y)
    ];

    DOSTRING(L,
        "x = X()\n"
        "info = class_info(x)\n"
        "assert(info.name == 'X')\n"
        "assert(info.methods['f'] == x.f)\n"
        "assert(info.methods['__init'] == x.__init)\n"
        "attrs = info.attributes\n"
        "assert(attrs[1] == 'x' or attrs[2] == 'x')\n"
        "assert(attrs[1] == 'y' or attrs[2] == 'y')\n"
        "info = class_info(2)\n"
        "assert(info.name == 'number')\n"
        "assert(#info.methods == 0)\n"
        "assert(#info.attributes == 0)\n"
        "names = class_names()\n"
        "assert(type(names) == 'table')\n"
        "assert(#names == 2)\n"
        "assert(names[1] == 'X' or names[2] == 'X')\n"
        "assert(names[1] == 'class_info_data' or names[2] == 'class_info_data')\n");

    DOSTRING(L,
        "info = class_info(X)\n"
        "assert(info.name == 'X')\n"
        "assert(info.methods['f'] == X().f)\n"
        "assert(info.methods['__init'] == X().__init)\n"
        "attrs = info.attributes\n"
        "assert(attrs[1] == 'x' or attrs[2] == 'x')\n"
        "assert(attrs[1] == 'y' or attrs[2] == 'y')\n"
    );

    DOSTRING(L,
        "s = tostring(X)\n"
        "assert(s:match('^class X (.+)$'))"
    );
    DOSTRING(L, "print(X)");
}
