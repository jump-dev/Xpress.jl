# Copyright (c) 2016: Joaquim Garcia, and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

module Lib

import ..Xpress
const libxprs = Xpress.libxprs

include("common.jl")
include("xprs.jl")

end  # Lib
