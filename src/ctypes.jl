# Copyright (c) 2016: Joaquim Garcia, and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

## TODO: pending https://github.com/JuliaLang/julia/issues/29420
# this one is suggested in the issue, but it looks like time_t and tm are two different things?
# const Ctime_t = Base.Libc.TmStruct

const Ctm = Base.Libc.TmStruct
const Ctime_t = UInt
const Cclock_t = UInt
