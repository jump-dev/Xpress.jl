"""

    copycallbacks(dest, src)

*Purpose*

Copies
callback functions defined for one problem to another.

*Synopsis*

int XPRS_CC XPRScopycallbacks(XPRSprob dest, XPRSprob src);

*Arguments*

`dest`: The problem to which the callbacks are copied.
`src`: The problem from which the callbacks are copied.

*Example*

The following sets up a message callback function
callback for problem
prob1 and then copies this to the problem
prob2.

*Related*

XPRScopycontrols,
XPRScopyprob.
"""
function copycallbacks(dest::XpressProblem, src::XpressProblem)
    @checked Lib.XPRScopycallbacks(dest, src)
end

"""

    copycontrols(dest, src)

*Purpose*

Copies
controls defined for one problem to another.

*Synopsis*

int XPRS_CC XPRScopycontrols(XPRSprob dest, XPRSprob src);

*Arguments*

`dest`: The problem to which the controls are copied.
`src`: The problem from which the controls are copied.

*Example*

The following turns off Presolve for problem
prob1 and then copies this and other control values to the problem
prob2 :

*Related*

XPRScopycallbacks,
XPRScopyprob.
"""
function copycontrols(dest::XpressProblem, src::XpressProblem)
    @checked Lib.XPRScopycontrols(dest, src)
    return dest
end

"""

    copyprob(dest, src, probname)

*Purpose*

Copies information defined for one
problem to another.

*Synopsis*

int XPRS_CC XPRScopyprob(XPRSprob dest, XPRSprob src, const char *probname);

*Arguments*

`dest`: The new problem pointer to which information is copied.
`src`: The old problem pointer from which information is copied.
`probname`: A string of up to 1024 characters (including

*Example*

The following copies the problem, its controls and it callbacks from
prob1 to
prob2:

*Related*

XPRScopycallbacks,
XPRScopycontrols,
XPRScreateprob.
"""
function copyprob(dest::XpressProblem, src::XpressProblem, probname="")
    @checked Lib.XPRScopyprob(dest, src, probname)
    return dest
end

"""

    createprob(_probholder)

*Purpose*

Sets up a new
problem within the Optimizer.

*Synopsis*

int XPRS_CC XPRScreateprob(XPRSprob *prob);

*Arguments*

`prob`: Pointer to a variable holding the new problem.

*Example*

The following creates a problem which will contain
myprob:

*Related*

XPRSdestroyprob,
XPRScopyprob,
XPRSinit.
"""
function createprob(_probholder)
    @checked Lib.XPRScreateprob(_probholder)
end

"""

    destroyprob(prob::XpressProblem)

*Purpose*

Removes a given
problem and frees any
memory associated with it following manipulation and optimization.

*Synopsis*

int XPRS_CC XPRSdestroyprob(XPRSprob prob);

*Arguments*

`prob`: The problem to be destroyed.

*Example*

The following creates, loads and solves a problem called
myprob, before subsequently freeing any resources allocated to it:

*Related*

XPRScreateprob,
XPRSfree,
XPRSinit.
"""
function destroyprob(prob::XpressProblem)
    @checked Lib.XPRSdestroyprob(prob)
end

"""

    init()

*Purpose*

Initializes the Optimizer library. This must be called before any other library routines.

*Synopsis*

int XPRS_CC XPRSinit(const char *xpress);

*Arguments*

`xpress`: The directory where the FICO Xpress password file is located. Users should employ a value of

*Example*

The following is the usual way of calling
XPRSinit :

*Related*

XPRScreateprob,
XPRSfree,
XPRSgetlicerrmsg.
"""
function init()
    @checked Lib.XPRSinit(C_NULL)
end

"""

    free()

*Purpose*

Frees any allocated
memory and closes all open files.

*Synopsis*

int XPRS_CC XPRSfree(void);

*Arguments*

[]

*Example*

The following frees resources allocated to the problem
prob and then tidies up before exiting:

*Related*

XPRSdestroyprob,
XPRSinit.
"""
function free()
    @checked Lib.XPRSfree()
end

"""

    getbanner()

*Purpose*

Returns the banner and copyright message.

*Synopsis*

int XPRS_CC XPRSgetbanner(char *banner);

*Arguments*

`banner`: Buffer long enough to hold the banner (plus a null terminator). This can be at most 512 characters.

*Example*

The following calls
XPRSgetbanner to return banner information at the start of the program:

*Related*

XPRSinit.
"""
function getbanner()
    banner = @invoke Lib.XPRSgetbanner(_)::String
    return banner
end

"""

    getversion()

*Purpose*

Returns the full Optimizer version number in the form 15.10.03, where 15 is the major release, 10 is the minor release, and 03 is the build number.

*Synopsis*

int XPRS_CC XPRSgetversion(char *version);

*Arguments*

`version`: Buffer long enough to hold the version string (plus a null terminator). This should be at least 16 characters.

*Example*

The following calls
XPRSgetversion to return version information at the start of the program:

*Related*

XPRSinit.
"""
function getversion()
    version = @invoke Lib.XPRSgetversion(_)::String
    return VersionNumber(parse.(Int, split(version, "."))...)
end

"""

    getdaysleft()

*Purpose*

Returns the number of days left until an evaluation license expires.

*Synopsis*

int XPRS_CC XPRSgetdaysleft(int *days);

*Arguments*

`days`: Pointer to an integer where the number of days is to be returned.

*Example*

The following calls
XPRSgetdaysleft to print information about the license:

*Related*

XPRSgetbanner.
"""
function getdaysleft()
    daysleft = @invoke Lib.XPRSgetdaysleft(_)::Int
end

"""

    setcheckedmode(checked_mode)

*Purpose*

You can use this function to disable some of the checking and validation of function calls and function call parameters for calls to the Xpress Optimizer API. This checking is relatively lightweight but disabling it can improve performance in cases where non-intensive Xpress Optimizer functions are called repeatedly in a short space of time. Please note: after disabling function call checking and validation, invalid usage of Xpress Optimizer functions may not be detected and may cause the Xpress Optimizer process to behave unexpectedly or crash. It is not recommended that you disable function call checking and validation during application development.

*Synopsis*

int XPRS_CC XPRSsetcheckedmode(int checked_mode);

*Arguments*

`checked_mode`: Pass as 0 to disable much of the validation for all Xpress function calls from the current process. Pass 1 to re-enable validation. By default, validation is enabled.

*Example*



*Related*

XPRSgetcheckedmode.
"""
function setcheckedmode(checked_mode)
    @checked Lib.XPRSsetcheckedmode(checked_mode)
end

"""

    getcheckedmode(r_checked_mode)

*Purpose*

You can use this function to interrogate whether checking and validation of all Optimizer function calls is enabled for the current process. Checking and validation is enabled by default but can be disabled by
XPRSsetcheckedmode.

*Synopsis*

int XPRS_CC XPRSgetcheckedmode(int* r_checked_mode);

*Arguments*

`r_checked_mode`: Variable that is set to 0 if checking and validation of Optimizer function calls is disabled for the current process, non-zero otherwise.

*Example*



*Related*

XPRSsetcheckedmode.
"""
function getcheckedmode(r_checked_mode)
    @checked Lib.XPRSgetcheckedmode(r_checked_mode)
end

function license(lic, path)
    r = Lib.XPRSlicense(lic, path)
end

function beginlicensing(r_dontAlreadyHaveLicense)
    @checked Lib.XPRSbeginlicensing(r_dontAlreadyHaveLicense)
end

function endlicensing()
    @checked Lib.XPRSendlicensing()
end

"""

    getlicerrmsg()

*Purpose*

Retrieves an error message describing the last licensing error, if any occurred.

*Synopsis*

int XPRS_CC XPRSgetlicerrmsg(char *buffer, int length);

*Arguments*

`buffer`: Buffer long enough to hold the error message (plus a null terminator).
`length`: Length of the buffer. This should be 512 or more since messages can be quite long.

*Example*

The following calls
XPRSgetlicerrmsg to find out why
XPRSinit failed:

*Related*

XPRSinit.
"""
function getlicerrmsg()
    msg = Cstring(pointer(Array{Cchar}(undef, 1024*8)))
    len = length(msg)
    @checked Lib.XPRSgetlicerrmsg(msg, len)
    return unsafe_string(msg)
end

"""

    setlogfile(prob::XpressProblem, logname)

*Purpose*

This directs all Optimizer output to a
log file.

*Synopsis*

int XPRS_CC XPRSsetlogfile(XPRSprob prob, const char *filename);

*Arguments*

`prob`: The current problem.
`filename`: A string of up to
`MAXPROBNAMELENGTH characters containing the file name to which all logging output should be written. If set to`: NULL, redirection of the output will stop and all screen output will be turned back on (except for DLL users where screen output is always turned off).

*Example*

The following directs output to the file
logfile.log:

*Related*

XPRSaddcbmessage.
"""
function setlogfile(prob::XpressProblem, logname::String)
    @checked Lib.XPRSsetlogfile(prob, logname)
end

"""

    setintcontrol(prob::XpressProblem, _index, _ivalue)

*Purpose*

Sets the value of a given integer
control parameter.

*Synopsis*

int XPRS_CC XPRSsetintcontrol(XPRSprob prob, int ipar, int isval);

*Arguments*

`prob`: The current problem.
`ipar`: Control parameter whose value is to be set. A full list of all controls may be found in
`Control Parameters, or from the list in the`: xprs.h header file.
`isval`: Value to which the control parameter is to be set.

*Example*

The following sets the control
PRESOLVE to
0, turning off the presolve facility prior to optimization:

*Related*

XPRSgetintcontrol,
XPRSsetdblcontrol,
XPRSsetstrcontrol.
"""
function setintcontrol(prob::XpressProblem, _index::Integer, _ivalue::Integer)
    @checked Lib.XPRSsetintcontrol(prob, _index, _ivalue)
end

function setintcontrol64(prob::XpressProblem, _index::Integer, _ivalue::Integer)
    @checked Lib.XPRSsetintcontrol64(prob, _index, _ivalue)
end

"""

    setdblcontrol(prob::XpressProblem, _index, _dvalue)

*Purpose*

Sets the value of a given double
control parameter.

*Synopsis*

int XPRS_CC XPRSsetdblcontrol(XPRSprob prob, int ipar, double dsval);

*Arguments*

`prob`: The current problem.
`ipar`: Control parameter whose value is to be set. A full list of all controls may be found in
`Control Parameters, or from the list in the`: xprs.h header file.
`dsval`: Value to which the control parameter is to be set.

*Example*



*Related*

XPRSgetdblcontrol,
XPRSsetintcontrol,
XPRSsetstrcontrol.
"""
function setdblcontrol(prob::XpressProblem, _index::Integer, _dvalue::AbstractFloat)
    @checked Lib.XPRSsetdblcontrol(prob, _index, _dvalue)
end

"""

    interrupt(prob::XpressProblem, reason)

*Purpose*

Interrupts the Optimizer algorithms.

*Synopsis*

int XPRS_CC XPRSinterrupt(XPRSprob prob, int reason);

*Arguments*

`prob`: The current problem.
`reason`: The reason for stopping. Possible reasons are:
`XPRS_STOP_TIMELIMIT`: time limit hit;
`XPRS_STOP_CTRLC`: control C hit;
`XPRS_STOP_NODELIMIT`: node limit hit;
`XPRS_STOP_ITERLIMIT`: iteration limit hit;
`XPRS_STOP_MIPGAP`: MIP gap is sufficiently small;
`XPRS_STOP_SOLLIMIT`: solution limit hit;
`XPRS_STOP_USER`: user interrupt.

*Example*



*Related*

None.
"""
function interrupt(prob::XpressProblem, reason)
    @checked Lib.XPRSinterrupt(prob, reason)
end

"""

    getprobname(prob::XpressProblem)

*Purpose*

Returns the current
problem name.

*Synopsis*

int XPRS_CC XPRSgetprobname(XPRSprob prob, char *probname);

*Arguments*

`prob`: The current problem.
`probname`: A string of up to

*Example*



*Related*

XPRSsetprobname,
MAXPROBNAMELENGTH.
"""
function getprobname(prob::XpressProblem)
    @invoke Lib.XPRSgetprobname(prob, _)::String
end

"""

    getqobj(prob::XpressProblem, _icol, _jcol, _dval)

*Purpose*

Returns a single
quadratic objective function coefficient corresponding to the variable pair
(icol, jcol) of the
Hessian matrix.

*Synopsis*

int XPRS_CC XPRSgetqobj(XPRSprob prob, int icol, int jcol, double *dval);

*Arguments*

`prob`: The current problem.
`icol`: Column index for the first variable in the quadratic term.
`jcol`: Column index for the second variable in the quadratic term.
`dval`: Pointer to a double value where the objective function coefficient is to be placed.

*Example*

The following returns the coefficient of the x
0
2 term in the objective function, placing it in the variable
value :

*Related*

XPRSgetmqobj,
XPRSchgqobj,
XPRSchgmqobj.
"""
function getqobj(prob::XpressProblem, _icol, _jcol, _dval)
    @checked Lib.XPRSgetqobj(prob, _icol, _jcol, _dval)
end

"""

    setprobname(prob::XpressProblem, name::AbstractString)

*Purpose*

Sets the current default
problem name. This command is rarely used.

*Synopsis*

int XPRS_CC XPRSsetprobname(XPRSprob prob, const char *probname);

*Arguments*

`prob`: The current problem.
`probname`: A string of up to

*Example*

READPROB bob
LPOPTIMIZE
SETPROBNAME jim
READPROB

*Related*

XPRSreadprob (
READPROB),
XPRSgetprobname,
MAXPROBNAMELENGTH.
"""
function setprobname(prob::XpressProblem, name::AbstractString)
    @checked Lib.XPRSsetprobname(prob, name)
end

"""

    setstrcontrol(prob::XpressProblem, _index, _svalue)

*Purpose*

Used to set the value of a given string
control parameter.

*Synopsis*

int XPRS_CC XPRSsetstrcontrol(XPRSprob prob, int ipar, const char *csval);

*Arguments*

`prob`: The current problem.
`ipar`: Control parameter whose value is to be set. A full list of all controls may be found in
`Control Parameters, or from the list in the`: xprs.h header file.
`csval`: A string containing the value to which the control is to be set (plus a null terminator).

*Example*

The following sets the control
MPSOBJNAME to
"Profit":

*Related*

XPRSgetstrcontrol,
XPRSsetdblcontrol,
XPRSsetintcontrol.
"""
function setstrcontrol(prob::XpressProblem, _index::Integer)
    @invoke Lib.XPRSsetstrcontrol(prob, _index, _)::String
end

"""

    getintcontrol(prob::XpressProblem, _index, _ivalue)

*Purpose*

Enables users to recover the values of various integer
control parameters

*Synopsis*

int XPRS_CC XPRSgetintcontrol(XPRSprob prob, int ipar, int *igval);

*Arguments*

`prob`: The current problem.
`ipar`: Control parameter whose value is to be returned. A full list of all controls may be found in Chapter
`Control Parameters, or from the list in the`: xprs.h header file.
`igval`: Pointer to an integer where the value of the control will be returned.

*Example*

The following obtains the value of
DEFAULTALG and outputs it to screen:

*Related*

XPRSsetintcontrol,
XPRSgetdblcontrol,
XPRSgetstrcontrol.
"""
function getintcontrol(prob::XpressProblem, _index::Integer)
    @invoke Lib.XPRSgetintcontrol(prob, _index, _)::Int
end

function getintcontrol64(prob::XpressProblem, _index::Integer)
    @invoke Lib.XPRSgetintcontrol64(prob, _index, _)::Int
end

"""

    getdblcontrol(prob::XpressProblem, _index, _dvalue)

*Purpose*

Retrieves the value of a given double
control parameter.

*Synopsis*

int XPRS_CC XPRSgetdblcontrol(XPRSprob prob, int ipar, double *dgval);

*Arguments*

`prob`: The current problem.
`ipar`: Control parameter whose value is to be returned. A full list of all controls may be found in Chapter
`Control Parameters, or from the list in the`: xprs.h header file.
`dgval`: Pointer to the location where the control value will be returned.

*Example*

The following returns the integer feasibility tolerance:

*Related*

XPRSsetdblcontrol,
XPRSgetintcontrol,
XPRSgetstrcontrol.
"""
function getdblcontrol(prob::XpressProblem, _index::Integer)
    @invoke Lib.XPRSgetdblcontrol(prob, _index, _)::Float64
end

"""

    getstrcontrol(prob::XpressProblem, _index, _svalue)

*Purpose*

Returns the value of a given string
control parameters.

*Synopsis*

int XPRS_CC XPRSgetstrcontrol(XPRSprob prob, int ipar, char *cgval);

*Arguments*

`prob`: The current problem.
`ipar`: Control parameter whose value is to be returned. A full list of all controls may be found in
`Control Parameters, or from the list in the`: xprs.h header file.
`cgval`: Pointer to a string where the value of the control (plus null terminator) will be returned.
`cgvalsize`: Maximum number of bytes to be written into the cgval argument.
`controlsize`: Returns the length of the string control including the null terminator.

*Example*



*Related*

XPRSgetdblcontrol,
XPRSgetintcontrol,
XPRSsetstrcontrol.
"""
function getstrcontrol(prob::XpressProblem, _index::Integer)
    @invoke Lib.XPRSgetstrcontrol(prob, _index, _)::String
end

function getstringcontrol(prob::XpressProblem, _index::Integer, _svalue, _svaluesize, _controlsize)
    @checked Lib.XPRSgetstringcontrol(prob, _index, _svalue, _svaluesize, _controlsize)
end

"""

    getintattrib(prob::XpressProblem, _index, _ivalue)

*Purpose*

Enables users to recover the values of various integer
problem attributes. Problem attributes are set during loading and optimization of a problem.

*Synopsis*

int XPRS_CC XPRSgetintattrib(XPRSprob prob, int ipar, int *ival);

*Arguments*

`prob`: The current problem.
`ipar`: Problem attribute whose value is to be returned. A full list of all problem attributes may be found in Chapter
`Problem Attributes, or from the list in the`: xprs.h header file.
`ival`: Pointer to an integer where the value of the problem attribute will be returned.

*Example*

The following obtains the number of columns in the matrix and allocates space to obtain lower bounds for each column:

*Related*

XPRSgetdblattrib,
XPRSgetstrattrib.
"""
function getintattrib(prob::XpressProblem, _index::Integer)
    @invoke Lib.XPRSgetintattrib(prob, _index, _)::Int
end

function getintattrib64(prob::XpressProblem, _index::Integer)
    @invoke Lib.XPRSgetintattrib64(prob, _index, _)::Int
end

"""

    getstrattrib(prob::XpressProblem, _index, _cvalue)

*Purpose*

Enables users to recover the values of various string
problem attributes. Problem attributes are set during loading and optimization of a problem.

*Synopsis*

int XPRS_CC XPRSgetstrattrib(XPRSprob prob, int ipar, char *cval);

*Arguments*

`prob`: The current problem.
`ipar`: Problem attribute whose value is to be returned. A full list of all problem attributes may be found in
`Problem Attributes, or from the list in the`: xprs.h header file.
`cval`: Pointer to a string where the value of the attribute (plus null terminator) will be returned.
`cgvalsize`: Maximum number of bytes to be written into the cgval argument.
`controlsize`: Returns the length of the string control including the null terminator.

*Example*



*Related*

XPRSgetdblattrib,
XPRSgetintattrib.
"""
function getstrattrib(prob::XpressProblem, _index::Integer)
    @invoke Lib.XPRSgetstrattrib(prob, _index, _)::String
end

function getstringattrib(prob::XpressProblem, _index::Integer, _cvalue, _cvaluesize, _controlsize)
    @checked Lib.XPRSgetstringattrib(prob, _index, _cvalue, _cvaluesize, _controlsize)
end

"""

    getdblattrib(prob::XpressProblem, _index, _dvalue)

*Purpose*

Enables users to retrieve the values of various double
problem attributes. Problem attributes are set during loading and optimization of a problem.

*Synopsis*

int XPRS_CC XPRSgetdblattrib(XPRSprob prob, int ipar, double *dval);

*Arguments*

`prob`: The current problem.
`ipar`: Problem attribute whose value is to be returned. A full list of all available problem attributes may be found in Chapter
`Problem Attributes, or from the list in the`: xprs.h header file.
`dval`: Pointer to a double where the value of the problem attribute will be returned.

*Example*

The following obtains the optimal value of the objective function and displays it to the console:

*Related*

XPRSgetintattrib,
XPRSgetstrattrib.
"""
function getdblattrib(prob::XpressProblem, _index::Integer)
    @invoke Lib.XPRSgetdblattrib(prob, _index, _)::Float64
end

"""

    setdefaultcontrol(prob::XpressProblem, _index)

*Purpose*

Sets a single control to its default value.

*Synopsis*

int XPRS_CC XPRSsetdefaultcontrol(XPRSprob prob, int ipar);

*Arguments*

`prob`: The current problem.
`ipar`: Integer, double or string control parameter whose default value is to be set.
`controlname`: Integer, double or string control parameter whose default value is to be set.

*Example*

The following turns off presolve to solve a problem, before resetting it to its default value and solving it again:

*Related*

XPRSsetdefaults,
XPRSsetintcontrol,
XPRSsetdblcontrol,
XPRSsetstrcontrol.
"""
function setdefaultcontrol(prob::XpressProblem, _index::Integer)
    @checked Lib.XPRSsetdefaultcontrol(prob, _index)
end

"""

    setdefaults(prob::XpressProblem)

*Purpose*

Sets all controls to their default values. Must be called before the problem is read or loaded by
XPRSreadprob,
XPRSloadglobal,
XPRSloadlp,
XPRSloadqglobal,
XPRSloadqp.

*Synopsis*

int XPRS_CC XPRSsetdefaults(XPRSprob prob);

*Arguments*

`prob`: The current problem.

*Example*

The following turns off presolve to solve a problem, before resetting the control defaults, reading it and solving it again:

*Related*

XPRSsetdefaultcontrol,
XPRSsetintcontrol,
XPRSsetdblcontrol,
XPRSsetstrcontrol.
"""
function setdefaults(prob::XpressProblem)
    @checked Lib.XPRSsetdefaults(prob)
end

"""

    getcontrolinfo(prob::XpressProblem, sCaName, iHeaderId, iTypeinfo)

*Purpose*

Accesses the id number and the type information of a control given its name. A control name may be for example
XPRS_PRESOLVE. Names are case-insensitive and may or may not have the
XPRS_ prefix. The id number is the constant used to identify the control for calls to functions such as
XPRSgetintcontrol. The function will return an id number of
0 and a type value of
XPRS_TYPE_NOTDEFINED if the name is not recognized as a control name. Note that this will occur if the name is an attribute name and not a control name. The type information returned will be one of the below integer constants defined in the
xprs.h header file.
XPRS_TYPE_NOTDEFINED
The name was not recognized.
XPRS_TYPE_INT
32 bit integer.
XPRS_TYPE_INT64
64 bit integer.
XPRS_TYPE_DOUBLE
Double precision floating point.
XPRS_TYPE_STRING
String.

*Synopsis*

int XPRS_CC XPRSgetcontrolinfo(XPRSprob prob, const char* sCaName, int* iHeaderId, int* iTypeinfo);

*Arguments*

`prob`: The current problem.
`sCaName`: The name of the control to be queried. Names are case-insensitive and may or may not have the
`XPRS_ prefix. A full list of all controls may be found in`: Control Parameters, or from the list in the
`xprs.h header file.`: iHeaderId
`Pointer to an integer where the id number will be returned.`: iTypeInfo

*Example*

The following code example obtains the id number and the type information of the control or attribute with name given by
sCaName. Note that the name happens to be a control name in this example:

*Related*

XPRSgetattribinfo.
"""
function getcontrolinfo(prob::XpressProblem, sCaName, iHeaderId, iTypeinfo)
    @checked Lib.XPRSgetcontrolinfo(prob, sCaName, iHeaderId, iTypeinfo)
end

"""

    getattribinfo(prob::XpressProblem, sCaName, iHeaderId, iTypeinfo)

*Purpose*

Accesses the id number and the type information of an attribute given its name. An attribute name may be for example
XPRS_ROWS. Names are case-insensitive and may or may not have the
XPRS_ prefix. The id number is the constant used to identify the attribute for calls to functions such as
XPRSgetintattrib. The type information returned will be one of the below integer constants defined in the
xprs.h header file. The function will return an id number of 0 and a type value of
XPRS_TYPE_NOTDEFINED if the name is not recognized as an attribute name. Note that this will occur if the name is a control name and not an attribute name.
XPRS_TYPE_NOTDEFINED
The name was not recognized.
XPRS_TYPE_INT
32 bit integer.
XPRS_TYPE_INT64
64 bit integer.
XPRS_TYPE_DOUBLE
Double precision floating point.
XPRS_TYPE_STRING
String.

*Synopsis*

int XPRS_CC XPRSgetattribinfo(XPRSprob prob, const char* sCaName, int* iHeaderId, int* iTypeinfo);

*Arguments*

`prob`: The current problem.
`sCaName`: The name of the attribute to be queried. Names are case-insensitive and may or may not have the
`XPRS_ prefix. A full list of all attributes may be found in Chapter`: Control Parameters, or from the list in the
`xprs.h header file.`: iHeaderId
`Pointer to an integer where the id number will be returned.`: iTypeInfo

*Example*

The following code example obtains the id number and the type id of the control or attribute with name given by
sCaName. Note that the name happens to be a control name in this example:

*Related*

XPRSgetcontrolinfo.
"""
function getattribinfo(prob::XpressProblem, sCaName, iHeaderId, iTypeinfo)
    @checked Lib.XPRSgetattribinfo(prob, sCaName, iHeaderId, iTypeinfo)
end

"""

    goal(prob::XpressProblem, _filename, _sflags)

*Purpose*

This function is deprecated, and will be removed in future releases. Perform
goal programming.

*Synopsis*

int XPRS_CC XPRSgoal(XPRSprob prob, const char *filename, const char *flags);

*Arguments*

`prob`: The current problem.
`filename`: A string of up to
`MAXPROBNAMELENGTH characters containing the file name from which the directives are to be read (a`: .gol extension will be added).
`flags`: Flags to pass to
`XPRSgoal (`: GOAL):
`o`: optimization process logs to be displayed;
`l`: treat integer variables as linear;
`f`: write output into a file

*Example*

Suppose we have a problem where the weight for objective function
OBJ1 is unknown and we wish to perform goal programming, maximizing this row and relaxing the resulting constraint by 5% of the optimal value, then the following sequence will solve this problem:

*Related*

Goal Programming.
"""
function goal(prob::XpressProblem, _filename::String, _sflags::String="")
    @checked Lib.XPRSgoal(prob, _filename, _sflags)
end

"""

    readprob(prob::XpressProblem, _sprobname, _sflags)

*Purpose*

Reads an (X)MPS or LP format
matrix from file.

*Synopsis*

int XPRS_CC XPRSreadprob(XPRSprob prob, const char *probname, const char *flags);

*Arguments*

`prob`: The current problem.
`probname`: The path and file name from which the problem is to be read. Limited to
`MAXPROBNAMELENGTH characters. If omitted (console users only), the default`: problem_name is used with various extensions - see below.
`flags`: Flags to be passed:
`l`: only
`probname.lp is searched for;`: z
`read input file in gzip format from a`: .gz file [ Console only ]

*Example*

READPROB -l

*Related*

XPRSloadglobal,
XPRSloadlp,
XPRSloadqglobal,
XPRSloadqp.
"""
function readprob(prob::XpressProblem, _sprobname::String, _sflags::String="")
    @checked Lib.XPRSreadprob(prob, _sprobname, _sflags)
end

"""

    loadlp(prob::XpressProblem, _sprobname="", ncols=0, nrows=0, _srowtypes=Cchar[], _drhs=Float64[], _drange=Float64[], _dobj=Float64[], _mstart=Int[], _mnel=Int[], _mrwind=Int[], _dmatval=Float64[], _dlb=Float64[], _dub=Float64[])

*Purpose*

Enables the user to pass a
matrix directly to the
Optimizer, rather than reading the matrix from a file.

*Synopsis*

int XPRS_CC XPRSloadlp(XPRSprob prob, const char *probname, int ncol, int nrow, const char qrtype[], const double rhs[], const double range[], const double obj[], const int mstart[], const int mnel[], const int mrwind[], const double dmatval[], const double dlb[], const double dub[]);

*Arguments*

`prob`: The current problem.
`probname`: A string of up to
`MAXPROBNAMELENGTH characters containing a names for the problem.`: ncol
`Number of structural columns in the matrix.`: nrow
`Number of rows in the matrix (not including the objective). Objective coefficients must be supplied in the`: obj array, and the objective function should not be included in any of the other arrays.
`qrtype`: Character array of length
`nrow containing the row types:`: L
`indicates a â¤ constraint;`: E
`indicates an = constraint;`: G
`indicates a â¥ constraint;`: R
`indicates a range constraint;`: N
`indicates a nonbinding constraint.`: rhs
`Double array of length`: nrow containing the right hand side coefficients of the rows. The right hand side value for a range row gives the
`upper bound on the row.`: range
`Double array of length`: nrow containing the range values for range rows. Values for all other rows will be ignored. May be
`NULL if not required. The lower bound on a range row is the right hand side value minus the range value. The sign of the range value is ignored - the absolute value is used in all cases.`: obj
`Double array of length`: ncol containing the objective function coefficients.
`mstart`: Integer array containing the offsets in the
`mrwind and`: dmatval arrays of the start of the elements for each column. This array is of length
`ncol or, if`: mnel is
`NULL, length`: ncol+1. If
`mnel is`: NULL, the extra entry of
`mstart,`: mstart[ncol], contains the position in the
`mrwind and`: dmatval arrays at which an extra column would start, if it were present. In C, this value is also the length of the
`mrwind and`: dmatval arrays.
`mnel`: Integer array of length
`ncol containing the number of nonzero elements in each column. May be`: NULL if not required. This array is not required if the non-zero coefficients in the
`mrwind and`: dmatval arrays are continuous, and the
`mstart array has`: ncol+1 entries as described above.
`mrwind`: Integer array containing the row indices for the nonzero elements in each column. If the indices are input contiguously, with the columns in ascending order, the length of the
`mrwind is`: mstart[ncol-1]+mnel[ncol-1] or, if
`mnel is`: NULL,
`mstart[ncol].`: dmatval
`Double array containing the nonzero element values; length as for`: mrwind.
`dlb`: Double array of length
`ncol containing the lower bounds on the columns. Use`: XPRS_MINUSINFINITY to represent a lower bound of minus infinity.
`dub`: Double array of length
`ncol containing the upper bounds on the columns. Use`: XPRS_PLUSINFINITY to represent an upper bound of plus infinity.

*Example*

Given an LP problem:
maximize:
x + y
subject to:
2x
â¥
3
x + 2y
â¥
3
x + y
â¥
1
the following shows how this may be loaded into the Optimizer using
XPRSloadlp:

*Related*

XPRSloadglobal,
XPRSloadqglobal,
XPRSloadqp,
XPRSreadprob.
"""
function loadlp(prob::XpressProblem, _sprobname="", ncols=0, nrows=0, _srowtypes=Cchar[], _drhs=Float64[], _drange=Float64[], _dobj=Float64[], _mstart=Int[], _mnel=Int[], _mrwind=Int[], _dmatval=Float64[], _dlb=Float64[], _dub=Float64[])
    @checked Lib.XPRSloadlp(prob, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub)
end

function loadlp64(prob::XpressProblem, _sprobname="", ncols=0, nrows=0, _srowtypes=Cchar[], _drhs=Float64[], _drange=Float64[], _dobj=Float64[], _mstart=Int[], _mnel=Int[], _mrwind=Int[], _dmatval=Float64[], _dlb=Float64[], _dub=Float64[])
    @checked Lib.XPRSloadlp64(prob, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub)
end

"""

    loadqp(prob::XpressProblem, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub, nquads, _mqcol1, _mqcol2, _dqval)

*Purpose*

Used to load a
quadratic problem into the Optimizer data structure. Such a problem may have quadratic terms in its
objective function, although not in its constraints.

*Synopsis*

int XPRS_CC XPRSloadqp(XPRSprob prob, const char *probname, int ncol, int nrow, const char qrtype[], const double rhs[], const double range[], const double obj[], const int mstart[], const int mnel[], const int mrwind[], const double dmatval[], const double dlb[], const double dub[], int nqtr, const int mqc1[], const int mqc2[], const double dqe[]);

*Arguments*

`prob`: The current problem.
`probname`: A string of up to
`MAXPROBNAMELENGTH characters containing a names for the problem.`: ncol
`Number of structural columns in the matrix.`: nrow
`Number of rows in the matrix (not including the objective row). Objective coefficients must be supplied in the`: obj array, and the objective function should not be included in any of the other arrays.
`qrtype`: Character array of length
`nrow containing the row types:`: L
`indicates a â¤ constraint;`: E
`indicates an = constraint;`: G
`indicates a â¥ constraint;`: R
`indicates a range constraint;`: N
`indicates a nonbinding constraint.`: rhs
`Double array of length`: nrow containing the right hand side coefficients of the rows. The right hand side value for a range row gives the
`upper bound on the row.`: range
`Double array of length`: nrow containing the range values for range rows. Values for all other rows will be ignored. May be
`NULL if there are no ranged constraints. The lower bound on a range row is the right hand side value minus the range value. The sign of the range value is ignored - the absolute value is used in all cases.`: obj
`Double array of length`: ncol containing the objective function coefficients.
`mstart`: Integer array containing the offsets in the
`mrwind and`: dmatval arrays of the start of the elements for each column. This array is of length
`ncol or, if`: mnel is
`NULL, length`: ncol+1. If
`mnel is`: NULL the extra entry of
`mstart,`: mstart[ncol], contains the position in the
`mrwind and`: dmatval arrays at which an extra column would start, if it were present. In C, this value is also the length of the
`mrwind and`: dmatval arrays.
`mnel`: Integer array of length
`ncol containing the number of nonzero elements in each column. May be`: NULL if all elements are contiguous and
`mstart[ncol] contains the offset where the elements for column`: ncol+1 would start. This array is not required if the non-zero coefficients in the
`mrwind and`: dmatval arrays are continuous, and the
`mstart array has`: ncol+1 entries as described above. It may be
`NULL if not required.`: mrwind
`Integer array containing the row indices for the nonzero elements in each column. If the indices are input contiguously, with the columns in ascending order, the length of the`: mrwind is
`mstart[ncol-1]+mnel[ncol-1] or, if`: mnel is
`NULL,`: mstart[ncol].
`dmatval`: Double array containing the nonzero element values; length as for
`mrwind.`: dlb
`Double array of length`: ncol containing the lower bounds on the columns. Use
`XPRS_MINUSINFINITY to represent a lower bound of minus infinity.`: dub
`Double array of length`: ncol containing the upper bounds on the columns. Use
`XPRS_PLUSINFINITY to represent an upper bound of plus infinity.`: nqtr
`Number of quadratic terms.`: mqc1
`Integer array of size`: nqtr containing the column index of the first variable in each quadratic term.
`mqc2`: Integer array of size
`nqtr containing the column index of the second variable in each quadratic term.`: dqe
`Double array of size`: nqtr containing the quadratic coefficients.

*Example*

Minimize -6x
1 + 2x
1
2 - 2x
1x
2 + 2x
2
2 subject to x
1 + x
2 â¤ 1.9:

*Related*

XPRSloadglobal,
XPRSloadlp,
XPRSloadqglobal,
XPRSreadprob.
"""
function loadqp(prob::XpressProblem, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub, nquads, _mqcol1, _mqcol2, _dqval)
    @checked Lib.XPRSloadqp(prob, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub, nquads, _mqcol1, _mqcol2, _dqval)
end

function loadqp64(prob::XpressProblem, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub, nquads, _mqcol1, _mqcol2, _dqval)
    @checked Lib.XPRSloadqp64(prob, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub, nquads, _mqcol1, _mqcol2, _dqval)
end

"""

    loadqglobal(prob::XpressProblem, probname, ncols, nrows, qsenx, rhsx, range, objx, matbeg, matcnt, matind, dmtval, bndl, bndu, nquads, mqcol1, mqcol2, dqval, ngents, nsets, qgtype, mgcols, dlim, qstype, msstart, mscols, dref)

*Purpose*

Used to load a
global problem with quadratic
objective coefficients in to the Optimizer data structures.
Integer,
binary,
partial integer,
semi-continuous and
semi-continuous integer variables can be defined, together with
sets of type 1 and 2. The reference row values for the set members are passed as an array rather than specifying a reference row.

*Synopsis*

int XPRS_CC XPRSloadqglobal(XPRSprob prob, const char *probname, int ncol, int nrow, const char qrtype[], const double rhs[], const double range[], const double obj[], const int mstart[], const int mnel[], const int mrwind[], const double dmatval[], const double dlb[], const double dub[], int nqtr, const int mqc1[], const int mqc2[], const double dqe[], const int ngents, const int nsets, const char qgtype[], const int mgcols[], const double dlim[], const char qstype[], const int msstart[], const int mscols[], const double dref[]);

*Arguments*

`prob`: The current problem.
`probname`: A string of up to
`MAXPROBNAMELENGTH characters containing a name for the problem.`: ncol
`Number of structural columns in the matrix.`: nrow
`Number of rows in the matrix (not including the objective). Objective coefficients must be supplied in the`: obj array, and the objective function should not be included in any of the other arrays.
`qrtype`: Character array of length
`nrow containing the row type:`: L
`indicates a â¤ constraint;`: E
`indicates an = constraint;`: G
`indicates a â¥ constraint;`: R
`indicates a range constraint;`: N
`indicates a nonbinding constraint.`: rhs
`Double array of length`: nrow containing the right hand side coefficients. The right hand side value for a range row gives the
`upper bound on the row.`: range
`Double array of length`: nrow containing the range values for range rows. The values in the range array will only be read for
`R type rows. The entries for other type rows will be ignored. May be`: NULL if not required. The lower bound on a range row is the right hand side value minus the range value. The sign of the range value is ignored - the absolute value is used in all cases.
`obj`: Double array of length
`ncol containing the objective function coefficients.`: mstart
`Integer array containing the offsets in the`: mrwind and
`dmatval arrays of the start of the elements for each column. This array is of length`: ncol or, if
`mnel is`: NULL, length
`ncol+1.`: mnel
`Integer array of length`: ncol containing the number of nonzero elements in each column. May be
`NULL if not required. This array is not required if the non-zero coefficients in the`: mrwind and
`dmatval arrays are continuous, and the`: mstart array has
`ncol+1 entries as described above. It may be`: NULL if not required.
`mrwind`: Integer arrays containing the row indices for the nonzero elements in each column. If the indices are input contiguously, with the columns in ascending order, then the length of
`mrwind is`: mstart[ncol-1]+mnel[ncol-1] or, if
`mnel is`: NULL,
`mstart[ncol].`: dmatval
`Double array containing the nonzero element values length as for`: mrwind.
`dlb`: Double array of length
`ncol containing the lower bounds on the columns. Use`: XPRS_MINUSINFINITY to represent a lower bound of minus infinity.
`dub`: Double array of length
`ncol containing the upper bounds on the columns. Use`: XPRS_PLUSINFINITY to represent an upper bound of plus infinity.
`nqtr`: Number of quadratic terms.
`mqc1`: Integer array of size
`nqtr containing the column index of the first variable in each quadratic term.`: mqc2
`Integer array of size`: nqtr containing the column index of the second variable in each quadratic term.
`dqe`: Double array of size
`nqtr containing the quadratic coefficients.`: ngents
`Number of binary, integer, semi-continuous, semi-continuous integer and partial integer entities.`: nsets
`Number of SOS1 and SOS2 sets.`: qgtype
`Character array of length`: ngents containing the entity types:
`B`: binary variables;
`I`: integer variables;
`P`: partial integer variables;
`S`: semi-continuous variables;
`R`: semi-continuous integers.
`mgcols`: Integer array of length
`ngents containing the column indices of the global entities.`: dlim
`Double array of length`: ngents containing the integer limits for the partial integer variables and lower bounds for semi-continuous and semi-continuous integer variables (any entries in the positions corresponding to binary and integer variables will be ignored). May be
`NULL if not required.`: qstype
`Character array of length`: nsets containing:
`1`: SOS1 type sets;
`2`: SOS2 type sets.
`May be`: NULL if not required.
`msstart`: Integer array containing the offsets in the
`mscols and`: dref arrays indicating the start of the sets. This array is of length
`nsets+1, the last member containing the offset where set`: nsets+1 would start. May be
`NULL if not required.`: mscols
`Integer array of length`: msstart[nsets]-1 containing the columns in each set. May be
`NULL if not required.`: dref
`Double array of length`: msstart[nsets]-1 containing the reference row entries for each member of the sets. May be

*Example*

Minimize -6x
1 + 2x
1
2 - 2x
1x
2 + 2x
2
2 subject to x
1 + x
2 â¤ 1.9, where x
1 must be an integer:

*Related*

XPRSaddsetnames,
XPRSloadglobal,
XPRSloadlp,
XPRSloadqp,
XPRSreadprob.
"""
function loadqglobal(prob::XpressProblem, probname, ncols, nrows, qsenx, rhsx, range, objx, matbeg, matcnt, matind, dmtval, bndl, bndu, nquads, mqcol1, mqcol2, dqval, ngents, nsets, qgtype, mgcols, dlim, qstype, msstart, mscols, dref)
    @checked Lib.XPRSloadqglobal(prob, probname, ncols, nrows, qsenx, rhsx, range, objx, matbeg, matcnt, matind, dmtval, bndl, bndu, nquads, mqcol1, mqcol2, dqval, ngents, nsets, qgtype, mgcols, dlim, qstype, msstart, mscols, dref)
end

function loadqglobal64(prob::XpressProblem, probname, ncols, nrows, qsenx, rhsx, range, objx, matbeg, matcnt, matind, dmtval, bndl, bndu, nquads, mqcol1, mqcol2, dqval, ngents, nsets, qgtype, mgcols, dlim, qstype, msstart, mscols, dref)
    @checked Lib.XPRSloadqglobal64(prob, probname, ncols, nrows, qsenx, rhsx, range, objx, matbeg, matcnt, matind, dmtval, bndl, bndu, nquads, mqcol1, mqcol2, dqval, ngents, nsets, qgtype, mgcols, dlim, qstype, msstart, mscols, dref)
end

"""

    fixglobals(prob::XpressProblem, ifround)

*Purpose*

Fixes all the
global entities to the values of the last found MIP solution. This is useful for finding the
reduced costs for the continuous variables after the global variables have been fixed to their optimal values.

*Synopsis*

int XPRS_CC XPRSfixglobals(XPRSprob prob, int ifround);

*Arguments*

`prob`: The current problem.
`ifround`: If all global entities should be rounded to the nearest discrete value in the solution before being fixed.
`flags`: Flags to pass to FIXGLOBALS:
`r`: round all global entities to the nearest feasible value in the solution before being fixed;

*Example*

A similar set of commands at the console would be as follows:

*Related*

XPRSmipoptimize (
MIPOPTIMIZE).
"""
function fixglobals(prob::XpressProblem, ifround::Bool)
    @checked Lib.XPRSfixglobals(prob, ifround)
end

"""

    loadmodelcuts(prob::XpressProblem, nmodcuts, _mrows)

*Purpose*

Specifies that a set of
rows in the
matrix will be treated as model cuts.

*Synopsis*

int XPRS_CC XPRSloadmodelcuts(XPRSprob prob, int nmod, const int mrows[]);

*Arguments*

`prob`: The current problem.
`nmod`: The number of model cuts.
`mrows`: An array of row indices to be treated as cuts.

*Example*

This sets the first six matrix rows as model cuts in the global problem
myprob.

*Related*

Working with the Cut Manager.
"""
function loadmodelcuts(prob::XpressProblem, nmodcuts, _mrows)
    @checked Lib.XPRSloadmodelcuts(prob, nmodcuts, _mrows)
end

"""

    loaddelayedrows(prob::XpressProblem, nrows, _mrows)

*Purpose*

Specifies that a set of rows in the matrix will be treated as delayed rows during a global search. These are rows that must be satisfied for any integer solution, but will not be loaded into the active set of constraints until required.

*Synopsis*

int XPRS_CC XPRSloaddelayedrows(XPRSprob prob, int nrows, const int mrows[]);

*Arguments*

`prob`: The current problem.
`nrows`: The number of delayed rows.
`mrows`: An array of row indices to treat as delayed rows.

*Example*

This sets the first six matrix rows as delayed rows in the global problem
prob.

*Related*

XPRSloadmodelcuts.
"""
function loaddelayedrows(prob::XpressProblem, nrows, _mrows)
    @checked Lib.XPRSloaddelayedrows(prob, nrows, _mrows)
end

"""

    loaddirs(prob::XpressProblem, ndirs, _mcols, _mpri, _sbr, dupc, ddpc)

*Purpose*

Loads
directives into the matrix.

*Synopsis*

int XPRS_CC XPRSloaddirs(XPRSprob prob, int ndir, const int mcols[], const int mpri[], const char qbr[], const double dupc[], const double ddpc[]);

*Arguments*

`prob`: The current problem.
`ndir`: Number of directives.
`mcols`: Integer array of length
`ndir containing the column numbers. A negative value indicates a set number (the first set being`: -1, the second
`-2, and so on).`: mpri
`Integer array of length`: ndir containing the priorities for the columns or sets. Priorities must be between 0 and 1000. May be
`NULL if not required.`: qbr
`Character array of length`: ndir specifying the branching direction for each column or set:
`U`: the entity is to be forced up;
`D`: the entity is to be forced down;
`N`: not specified.
`May be`: NULL if not required.
`dupc`: Double array of length
`ndir containing the up pseudo costs for the columns or sets. May be`: NULL if not required.
`ddpc`: Double array of length
`ndir containing the down pseudo costs for the columns or sets. May be`: NULL if not required.

*Example*



*Related*

XPRSgetdirs,
XPRSloadpresolvedirs,
XPRSreaddirs.
"""
function loaddirs(prob::XpressProblem, ndirs, _mcols, _mpri, _sbr, dupc, ddpc)
    @checked Lib.XPRSloaddirs(prob, ndirs, _mcols, _mpri, _sbr, dupc, ddpc)
end

"""

    loadbranchdirs(prob::XpressProblem, ndirs, _mcols, _mbranch)

*Purpose*

Loads directives into the current problem to specify which global entities the Optimizer should continue to branch on when a node solution is global feasible.

*Synopsis*

int XPRS_CC XPRSloadbranchdirs(XPRSprob prob, int ndirs, const int mcols[], const int mbranch[]);

*Arguments*

`prob`: The current problem.
`ndirs`: Number of directives.
`mcols`: Integer array of length
`ndirs containing the column numbers. A negative value indicates a set number (the first set being -1, the second -2, and so on).`: mbranch
`Integer array of length`: ndirs containing either 0 or 1 for the entities given in
`mcols. Entities for which mbranch is set to 1 will be branched on until fixed before a global feasible solution is returned. If`: mbranch is NULL, the branching directive will be set for all entities in

*Example*



*Related*

XPRSloaddirs,
XPRSreaddirs,
The Directives (.dir) File.
"""
function loadbranchdirs(prob::XpressProblem, ndirs, _mcols, _mbranch)
    @checked Lib.XPRSloadbranchdirs(prob, ndirs, _mcols, _mbranch)
end

"""

    loadpresolvedirs(prob::XpressProblem, ndirs, _mcols, _mpri, _sbr, dupc, ddpc)

*Purpose*

Loads
directives into the
presolved matrix.

*Synopsis*

int XPRS_CC XPRSloadpresolvedirs(XPRSprob prob, int ndir, const int mcols[], const int mpri[], const char qbr[], const double dupc[], const double ddpc[]);

*Arguments*

`prob`: The current problem.
`ndir`: Number of directives.
`mcols`: Integer array of length
`ndir containing the column numbers. A negative value indicates a set number (`: -1 being the first set,
`-2 the second, and so on).`: mpri
`Integer array of length`: ndir containing the priorities for the columns or sets. May be
`NULL if not required.`: qbr
`Character array of length`: ndir specifying the branching direction for each column or set:
`U`: the entity is to be forced up;
`D`: the entity is to be forced down;
`N`: not specified.
`May be`: NULL if not required.
`dupc`: Double array of length
`ndir containing the up pseudo costs for the columns or sets. May be`: NULL if not required.
`ddpc`: Double array of length
`ndir containing the down pseudo costs for the columns or sets. May be`: NULL if not required.

*Example*

The following loads priority directives for column
0 in the matrix:

*Related*

XPRSgetdirs,
XPRSloaddirs.
"""
function loadpresolvedirs(prob::XpressProblem, ndirs, _mcols, _mpri, _sbr, dupc, ddpc)
    @checked Lib.XPRSloadpresolvedirs(prob, ndirs, _mcols, _mpri, _sbr, dupc, ddpc)
end

"""

    getdirs(prob::XpressProblem, ndirs, _mcols, _mpri, _sbr, dupc, ddpc)

*Purpose*

Used to return the
directives that have been loaded into a matrix.
Priorities, forced
branching directions and
pseudo costs can be returned. If called after presolve,
XPRSgetdirs will get the directives for the
presolved problem.

*Synopsis*

int XPRS_CC XPRSgetdirs(XPRSprob prob, int *ndir, int mcols[], int mpri[], char qbr[], double dupc[], double ddpc[]);

*Arguments*

`prob`: The current problem.
`ndir`: Pointer to an integer where the number of directives will be returned.
`mcols`: Integer array of length
`ndir containing the column numbers (`: 0,
`1,`: 2,...) or negative values corresponding to special ordered sets (the first set numbered
`-1, the second numbered`: -2,...). May be NULL if not required.
`mpri`: Integer array of length
`ndir containing the priorities for the columns and sets. May be NULL if not required.`: qbr
`Character array of length`: ndir specifying the branching direction for each column or set:
`U`: the entity is to be forced up;
`D`: the entity is to be forced down;
`N`: not specified.
`dupc`: Double array of length
`ndir containing the up pseudo costs for the columns and sets. May be NULL if not required.`: ddpc
`Double array of length`: ndir containing the down pseudo costs for the columns and sets. May be NULL if not required.

*Example*



*Related*

XPRSloaddirs,
XPRSloadpresolvedirs.
"""
function getdirs(prob::XpressProblem, ndirs, _mcols, _mpri, _sbr, dupc, ddpc)
    @checked Lib.XPRSgetdirs(prob, ndirs, _mcols, _mpri, _sbr, dupc, ddpc)
end

"""

    loadglobal(prob::XpressProblem, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub, ngents, nsets, _qgtype, _mgcols, _dlim, _stype, _msstart, _mscols, _dref)

*Purpose*

Used to load a
global problem in to the Optimizer data structures.
Integer,
binary,
partial integer,
semi-continuous and
semi-continuous integer variables can be defined, together with
sets of type 1 and 2. The reference row values for the set members are passed as an array rather than specifying a reference row.

*Synopsis*

int XPRS_CC XPRSloadglobal(XPRSprob prob, const char *probname, int ncol, int nrow, const char qrtype[], const double rhs[], const double range[], const double obj[], const int mstart[], const int mnel[], const int mrwind[], const double dmatval[], const double dlb[], const double dub[], int ngents, int nsets, const char qgtype[], const int mgcols[], const double dlim[], const char qstype[], const int msstart[], const int mscols[], const double dref[]);

*Arguments*

`prob`: The current problem.
`probname`: A string of up to
`MAXPROBNAMELENGTH characters containing a name for the problem.`: ncol
`Number of structural columns in the matrix.`: nrow
`Number of rows in the matrix not (including the objective row). Objective coefficients must be supplied in the`: obj array, and the objective function should not be included in any of the other arrays.
`qrtype`: Character array of length
`nrow containing the row types:`: L
`indicates a â¤ constraint;`: E
`indicates an = constraint;`: G
`indicates a â¥ constraint;`: R
`indicates a range constraint;`: N
`indicates a nonbinding constraint.`: rhs
`Double array of length`: nrow containing the right hand side coefficients. The right hand side value for a range row gives the
`upper bound on the row.`: range
`Double array of length`: nrow containing the range values for range rows. Values for all other rows will be ignored. May be
`NULL if not required. The lower bound on a range row is the right hand side value minus the range value. The sign of the range value is ignored - the absolute value is used in all cases.`: obj
`Double array of length`: ncol containing the objective function coefficients.
`mstart`: Integer array containing the offsets in the
`mrwind and`: dmatval arrays of the start of the elements for each column. This array is of length
`ncol or, if`: mnel is
`NULL, length`: ncol+1. If
`mnel is`: NULL, the extra entry of
`mstart,`: mstart[ncol], contains the position in the
`mrwind and`: dmatval arrays at which an extra column would start, if it were present. In C, this value is also the length of the
`mrwind and`: dmatval arrays.
`mnel`: Integer array of length
`ncol containing the number of nonzero elements in each column. May be`: NULL if not required. This array is not required if the non-zero coefficients in the
`mrwind and`: dmatval arrays are continuous, and the
`mstart array has`: ncol+1 entries as described above. It may be
`NULL if not required.`: mrwind
`Integer arrays containing the row indices for the nonzero elements in each column. If the indices are input contiguously, with the columns in ascending order, then the length of`: mrwind is
`mstart[ncol-1]+mnel[ncol-1] or, if`: mnel is
`NULL,`: mstart[ncol].
`dmatval`: Double array containing the nonzero element values length as for
`mrwind.`: dlb
`Double array of length`: ncol containing the lower bounds on the columns. Use
`XPRS_MINUSINFINITY to represent a lower bound of minus infinity.`: dub
`Double array of length`: ncol containing the upper bounds on the columns. Use
`XPRS_PLUSINFINITY to represent an upper bound of plus infinity.`: ngents
`Number of binary, integer, semi-continuous, semi-continuous integer and partial integer entities.`: nsets
`Number of SOS1 and SOS2 sets.`: qgtype
`Character array of length`: ngents containing the entity types:
`B`: binary variables;
`I`: integer variables;
`P`: partial integer variables;
`S`: semi-continuous variables;
`R`: semi-continuous integer variables.
`mgcols`: Integer array of length
`ngents containing the column indices of the global entities.`: dlim
`Double array of length`: ngents containing the integer limits for the partial integer variables and lower bounds for semi-continuous and semi-continuous integer variables (any entries in the positions corresponding to binary and integer variables will be ignored). May be
`NULL if not required.`: qstype
`Character array of length`: nsets containing the set types:
`1`: SOS1 type sets;
`2`: SOS2 type sets.
`May be`: NULL if not required.
`msstart`: Integer array containing the offsets in the
`mscols and`: dref arrays indicating the start of the sets. This array is of length
`nsets+1, the last member containing the offset where set`: nsets+1 would start. May be
`NULL if not required.`: mscols
`Integer array of length`: msstart[nsets]-1 containing the columns in each set. May be
`NULL if not required.`: dref
`Double array of length`: msstart[nsets]-1 containing the reference row entries for each member of the sets. May be

*Example*

The following specifies an integer problem,
globalEx, corresponding to:
maximize:
x + 2y
subject to:
3x + 2y
â¤
400
x + 3y
â¤
200
with both
x and
y integral:

*Related*

XPRSaddsetnames,
XPRSloadlp,
XPRSloadqglobal,
XPRSloadqp,
XPRSreadprob.
"""
function loadglobal(prob::XpressProblem, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub, ngents, nsets, _qgtype, _mgcols, _dlim, _stype, _msstart, _mscols, _dref)
    @checked Lib.XPRSloadglobal(prob, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub, ngents, nsets, _qgtype, _mgcols, _dlim, _stype, _msstart, _mscols, _dref)
end

function loadglobal64(prob::XpressProblem, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub, ngents, nsets, _qgtype, _mgcols, _dlim, _stype, _msstart, _mscols, _dref)
    @checked Lib.XPRSloadglobal64(prob, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub, ngents, nsets, _qgtype, _mgcols, _dlim, _stype, _msstart, _mscols, _dref)
end

"""

    addnames(prob::XpressProblem, _itype::Integer, _sname::Vector{String})

    addnames(prob::XpressProblem, _itype::Integer, first::Integer, _sname::Vector{String})

*Purpose*

When a model is loaded, the rows, columns and sets of the model may not have
names associated with them. This may not be important as the rows, columns and sets can be referred to by their sequence numbers. However, if you wish row, column and set names to appear in the ASCII solutions files, the names for a range of rows or columns can be added with
XPRSaddnames.

*Synopsis*

int XPRS_CC XPRSaddnames(XPRSprob prob, int type, const char cnames[], int first, int last);

*Arguments*

`prob`: The current problem.
`type`: 1
`for row names;`: 2
`for column names.`: 3
`for set names.`: cnames
`Character buffer containing the null-terminated string names.`: first
`Start of the range of rows, columns or sets.`: last

*Example*

Add variable names (
a and
b), objective function (
profit) and constraint names (
first and
second) to a problem:

*Related*

XPRSaddcols,
XPRSaddrows,
XPRSgetnames.
"""
function addnames(prob::XpressProblem, _itype::Integer, first::Integer, _sname::Vector{String})
    # TODO: name _itype a Enum?
    NAMELENGTH = 64

    last = first+length(names)-1
    first -= 1
    last -= 1

    _cnames = ""
    for str in names
        _cnames = string(_cnames, join(Base.Iterators.take(str,NAMELENGTH)), "\0")
    end

    @checked Lib.XPRSaddnames(prob, _itype, _cnames, first, last)
end
function addnames(prob::XpressProblem, _itype::Integer, _sname::Vector{String})
    addnames(prob, _itype, 1, _sname)
end

"""

    addsetnames(prob::XpressProblem, _sname, first, last)

*Purpose*

When a model with global entities is loaded, any special ordered sets may not have
names associated with them. If you wish names to appear in the ASCII solutions files, the names for a range of sets can be added with this function.

*Synopsis*

int XPRS_CC XPRSaddsetnames(XPRSprob prob, const char names[], int first, int last);

*Arguments*

`prob`: The current problem.
`names`: Character buffer containing the null-terminated string names.
`first`: Start of the range of sets.
`last`: End of the range of sets.

*Example*

Add set names (
set1 and
set2) to a problem:

*Related*

XPRSaddnames,
XPRSloadglobal,
XPRSloadqglobal.
"""
function addsetnames(prob::XpressProblem, _sname, first::Integer, last::Integer)
    @checked Lib.XPRSaddsetnames(prob, _sname, first, last)
end

"""

    scale(prob::XpressProblem, mrscal, mcscal)

*Purpose*

Re-scales
the current
matrix.

*Synopsis*

int XPRS_CC XPRSscale(XPRSprob prob, const int mrscal[], const int mcscal[]);

*Arguments*

`prob`: The current problem.
`mrscal`: Integer array of size
`ROWS containing the powers of`: 2 with which to scale the rows, or
`NULL if not required.`: mcscal
`Integer array of size`: COLS containing the powers of
`2 with which to scale the columns, or`: NULL if not required.

*Example*

The equivalent set of commands for the Console user would be:

*Related*

XPRSalter (
ALTER),
XPRSreadprob (
READPROB).
"""
function scale(prob::XpressProblem, mrscal, mcscal)
    @checked Lib.XPRSscale(prob, mrscal, mcscal)
end

"""

    readdirs(prob::XpressProblem, _sfilename)

*Purpose*

Reads a
directives file to help direct the
global search.

*Synopsis*

int XPRS_CC XPRSreaddirs(XPRSprob prob, const char *filename);

*Arguments*

`prob`: The current problem.
`filename`: A string of up to
`MAXPROBNAMELENGTH characters containing the file name from which the directives are to be read. If omitted (or`: NULL), the default
`problem_name is used with a`: .dir extension.

*Example*

READPROB
READDIRS
MIPOPTIMIZE

*Related*

XPRSloaddirs,
The Directives (.dir) File.
"""
function readdirs(prob::XpressProblem, _sfilename::String)
    @checked Lib.XPRSreaddirs(prob, _sfilename)
end

"""

    writedirs(prob::XpressProblem, _sfilename)

*Purpose*

Writes the global search directives from the current problem to a directives file.

*Synopsis*

int XPRS_CC XPRSwritedirs(XPRSprob prob, const char *filename);

*Arguments*

`prob`: The current problem.
`filename`: A string of up to
`MAXPROBNAMELENGTH characters containing the file name to which the directives should be written. If omitted (or NULL), the default`: problem_name is used with a

*Example*



*Related*

XPRSloaddirs,
The Directives (.dir) File.
"""
function writedirs(prob::XpressProblem, _sfilename::String)
    @checked Lib.XPRSwritedirs(prob, _sfilename)
end

"""

    setindicators(prob::XpressProblem, nrows, _mrows, _inds, _comps)

*Purpose*

Specifies that a set of rows in the matrix will be treated as indicator constraints, during a global search. An indicator constraint is made of a
condition and a
linear constraint. The
condition is of the type "
bin = value", where
bin is a binary variable and
value is either 0 or 1. The
linear constraint is any linear row. During global search, a row configured as an indicator constraint is enforced only when condition holds, that is only if the indicator variable
bin has the specified value.

*Synopsis*

int XPRS_CC XPRSsetindicators(XPRSprob prob, int nrows, const int mrows[], const int inds[], const int comps[]);

*Arguments*

`prob`: The current problem.
`nrows`: The number of indicator constraints.
`mrows`: Integer array of length
`nrows containing the indices of the rows that define the linear constraint part for the indicator constraints.`: inds
`Integer array of length`: nrows containing the column indices of the indicator variables.
`comps`: Integer array of length
`nrows with the complement flags:`: 0
`not an indicator constraint (in this case the corresponding entry in the`: inds array is ignored);
`1`: for indicator constraints with condition "
`bin = 1";`: -1
`for indicator constraints with condition "`: bin = 0";

*Example*

This sets the first two matrix rows as indicator rows in the global problem prob; the first row controlled by condition
x4=1 and the second row controlled by condition
x5=0 (assuming
x4 and
x5 correspond to columns indices 4 and 5).

*Related*

XPRSgetindicators,
XPRSdelindicators.
"""
function setindicators(prob::XpressProblem, nrows, _mrows, _inds, _comps)
    @checked Lib.XPRSsetindicators(prob, nrows, _mrows, _inds, _comps)
end

"""

    getindicators(prob::XpressProblem, _inds, _comps, first, last)

*Purpose*

Returns the indicator constraint condition (indicator variable and complement flag) associated to the rows in a given range.

*Synopsis*

int XPRS_CC XPRSgetindicators(XPRSprob prob, int inds[], int comps[], int first, int last);

*Arguments*

`prob`: The current problem.
`inds`: Integer array of length
`last-first+1 where the column indices of the indicator variables are to be placed.`: comps
`Integer array of length`: last-first+1 where the indicator complement flags will be returned:
`0`: not an indicator constraint (in this case the corresponding entry in the
`inds array is ignored);`: 1
`for indicator constraints with condition "`: bin = 1";
`-1`: for indicator constraints with condition "
`bin = 0";`: first
`First row in the range.`: last

*Example*

The following example retrieves information about all indicator constraints in the matrix and prints a list of their indices.

*Related*

XPRSsetindicators,
XPRSdelindicators.
"""
function getindicators(prob::XpressProblem, _inds, _comps, first::Integer, last::Integer)
    @checked Lib.XPRSgetindicators(prob, _inds, _comps, first, last)
end

"""

    delindicators(prob::XpressProblem, first, last)

*Purpose*

Delete indicator constraints. This turns the specified rows into normal rows (not controlled by indicator variables).

*Synopsis*

int XPRS_CC XPRSdelindicators(XPRSprob prob, int first, int last);

*Arguments*

`prob`: The current problem.
`first`: First row in the range.
`last`: Last row in the range (inclusive).

*Example*

In this example, if any of the first two rows of the matrix is an indicator constraint, they are turned into normal rows:

*Related*

XPRSgetindicators,
XPRSsetindicators.
"""
function delindicators(prob::XpressProblem, first::Integer, last::Integer)
    @checked Lib.XPRSdelindicators(prob, first, last)
end

"""

    dumpcontrols(prob::XpressProblem)

*Purpose*

Displays the list of controls and their current value for those controls that have been set to a non default value.

*Synopsis*

int XPRS_CC XPRSdumpcontrols(XPRSprob prob);

*Arguments*

[]

*Example*



*Related*

SETDEFAULTS,
SETDEFAULTCONTROL
"""
function dumpcontrols(prob::XpressProblem)
    @checked Lib.XPRSdumpcontrols(prob)
end

function minim(prob::XpressProblem, _sflags::String="")
    @checked Lib.XPRSminim(prob, _sflags)
end

"""

    maxim(prob::XpressProblem, _sflags)

*Purpose*

Begins a search for the optimal LP
solution. These functions are deprecated and might be removed in a future release.
XPRSlpoptimize or
XPRSmipoptimize should be used instead.

*Synopsis*

int XPRS_CC XPRSmaxim(XPRSprob prob, const char *flags);

*Arguments*

`prob`: The current problem.
`flags`: Flags to pass to
`XPRSmaxim (`: MAXIM) or
`XPRSminim (`: MINIM). The default is
`"" or`: NULL, in which case the algorithm used is determined by the
`DEFAULTALG control. If the argument includes:`: b
`the model will be solved using the Newton barrier method;`: p
`the model will be solved using the primal simplex algorithm;`: d
`the model will be solved using the dual simplex algorithm;`: l
`(lower case`: L), the model will be solved as a linear model ignoring the discreteness of global variables;
`n`: (lower case
`N), the network part of the model will be identified and solved using the network simplex algorithm;`: g
`the global model will be solved, calling`: XPRSglobal (
`GLOBAL).`: Certain combinations of options may be used where this makes sense so, for example,

*Example*

MINIM -g

*Related*

XPRSglobal (
GLOBAL),
XPRSreadbasis (
READBASIS),
XPRSgoal (
GOAL),
Solution Methods,
The Matrix Alteration (.alt) File.
"""
function maxim(prob::XpressProblem, _sflags::String="")
    @checked Lib.XPRSmaxim(prob, _sflags)
end

"""

    lpoptimize(prob::XpressProblem, _sflags)

*Purpose*

This function begins a search for the optimal continuous (LP) solution. The direction of optimization is given by
OBJSENSE. The status of the problem when the function completes can be checked using
LPSTATUS. Any global entities in the problem will be ignored.

*Synopsis*

int XPRS_CC XPRSlpoptimize(XPRSprob prob, const char *flags);

*Arguments*

`prob`: The current problem.
`flags`: Flags to pass to
`XPRSlpoptimize (`: LPOPTIMIZE). The default is
`"" or`: NULL, in which case the algorithm used is determined by the
`DEFAULTALG control. If the argument includes:`: b
`the model will be solved using the Newton barrier method;`: p
`the model will be solved using the primal simplex algorithm;`: d
`the model will be solved using the dual simplex algorithm;`: n
`(lower case`: N), the network part of the model will be identified and solved using the network simplex algorithm;

*Example*



*Related*

XPRSmipoptimize (
MIPOPTIMIZE),
Solution Methods.
"""
function XPRSlpoptimize(prob::XpressProblem, _sflags::String="")
    @checked Lib.XPRSlpoptimize(prob, _sflags)
end

"""

    mipoptimize(prob::XpressProblem, _sflags)

*Purpose*

This function begins a global search for the optimal MIP solution. The direction of optimization is given by
OBJSENSE. The status of the problem when the function completes can be checked using
MIPSTATUS.

*Synopsis*

int XPRS_CC XPRSmipoptimize(XPRSprob prob, const char *flags);

*Arguments*

`prob`: The current problem.
`flags`: Flags to pass to
`XPRSmipoptimize (`: MIPOPTIMIZE), which specifies how to solve the initial continuous problem where the global entities are relaxed. If the argument includes:
`b`: the initial continuous relaxation will be solved using the Newton barrier method;
`p`: the initial continuous relaxation will be solved using the primal simplex algorithm;
`d`: the initial continuous relaxation will be solved using the dual simplex algorithm;
`n`: the network part of the initial continuous relaxation will be identified and solved using the network simplex algorithm;
`l`: stop after having solved the initial continous relaxation.

*Example*



*Related*

XPRSlpoptimize (
LPOPTIMIZE),
Solution Methods.
"""
function mipoptimize(prob::XpressProblem, _sflags::String="")
    @checked Lib.XPRSmipoptimize(prob, _sflags)
end

"""

    range(prob::XpressProblem)

*Purpose*

Calculates the
ranging information for a problem and saves it to the binary ranging file
problem_name
.rng.

*Synopsis*

int XPRS_CC XPRSrange(XPRSprob prob);

*Arguments*

`prob`: The current problem.

*Example*

The following example is equivalent for the console, except the output is sent to the screen instead of a file:

*Related*

XPRSgetcolrange,
XPRSgetrowrange,
XPRSwriteprtrange (
WRITEPRTRANGE),
XPRSwriterange (
WRITERANGE).
"""
function range(prob::XpressProblem)
    @checked Lib.XPRSrange(prob)
end

"""

    getrowrange(prob::XpressProblem, _upact, _loact, _uup, _udn)

*Purpose*

Returns the row
ranges computed by
XPRSrange.

*Synopsis*

int XPRS_CC XPRSgetrowrange(XPRSprob prob, double upact[], double loact[], double uup[], double udn[]);

*Arguments*

`prob`: The current problem.
`upact`: Double array of length
`ROWS for the upper row activities.`: loact
`Double array of length`: ROWS for the lower row activities.
`uup`: Double array of length
`ROWS for the upper row unit costs.`: udn
`Double array of length`: ROWS for the lower row unit costs.

*Example*

The following computes row ranges and returns them:

*Related*

XPRSchgrhsrange,
XPRSgetcolrange.
"""
function getrowrange(prob::XpressProblem, _upact, _loact, _uup, _udn)
    @checked Lib.XPRSgetrowrange(prob, _upact, _loact, _uup, _udn)
end

"""

    getcolrange(prob::XpressProblem, _upact, _loact, _uup, _udn, _ucost, _lcost)

*Purpose*

Returns the column
ranges computed by
XPRSrange.

*Synopsis*

int XPRS_CC XPRSgetcolrange(XPRSprob prob, double upact[], double loact[], double uup[], double udn[], double ucost[], double lcost[]);

*Arguments*

`prob`: The current problem.
`upact`: Double array of length
`COLS for upper column activities.`: loact
`Double array of length`: COLS for lower column activities.
`uup`: Double array of length
`COLS for upper column unit costs.`: udn
`Double array of length`: COLS for lower column unit costs.
`ucost`: Double array of length
`COLS for upper costs.`: lcost
`Double array of length`: COLS for lower costs.

*Example*

Here the column ranges are retrieved into arrays as in the synopsis:

*Related*

XPRSgetrowrange,
XPRSrange.
"""
function getcolrange(prob::XpressProblem, _upact, _loact, _uup, _udn, _ucost, _lcost)
    @checked Lib.XPRSgetcolrange(prob, _upact, _loact, _uup, _udn, _ucost, _lcost)
end

"""

    getpivotorder(prob::XpressProblem, mpiv)

*Purpose*

Returns the
pivot order of the basic variables.

*Synopsis*

int XPRS_CC XPRSgetpivotorder(XPRSprob prob, int mpiv[]);

*Arguments*

`prob`: The current problem.
`mpiv`: Integer array of length

*Example*

The following returns the pivot order of the variables into an array
pPivot :

*Related*

XPRSgetpivots,
XPRSpivot.
"""
function getpivotorder(prob::XpressProblem, mpiv)
    @checked Lib.XPRSgetpivotorder(prob, mpiv)
end

"""

    getpresolvemap(prob::XpressProblem, rowmap, colmap)

*Purpose*

Returns the mapping of the row and column numbers from the presolve problem back to the original problem.

*Synopsis*

int XPRS_CC XPRSgetpresolvemap(XPRSprob prob, int rowmap[], int colmap[]);

*Arguments*

`prob`: The current problem.
`rowmap`: Integer array of length
`ROWS where the row maps will be returned.`: colmap
`Integer array of length`: COLS where the column maps will be returned.

*Example*

The following reads in a (Mixed) Integer Programming problem and gets the mapping for the rows and columns back to the original problem following optimization of the linear relaxation. The elimination operations of the presolve are turned off so that a one-to-one mapping between the presolve problem and the original problem.

*Related*

Working with Presolve.
"""
function getpresolvemap(prob::XpressProblem, rowmap, colmap)
    @checked Lib.XPRSgetpresolvemap(prob, rowmap, colmap)
end

"""

    readbasis(prob::XpressProblem, _sfilename, _sflags)

*Purpose*

Instructs the Optimizer to read in a previously saved
basis from a file.

*Synopsis*

int XPRS_CC XPRSreadbasis(XPRSprob prob, const char *filename, const char *flags);

*Arguments*

`prob`: The current problem.
`filename`: A string of up to
`MAXPROBNAMELENGTH characters containing the file name from which the basis is to be read. If omitted, the default`: problem_name is used with a
`.bss extension.`: flags
`Flags to pass to`: XPRSreadbasis (
`READBASIS):`: i
`output the internal presolved basis.`: t

*Example*

An equivalent set of commands for the Console user may look like:

*Related*

XPRSloadbasis,
XPRSwritebasis (
WRITEBASIS).
"""
function readbasis(prob::XpressProblem, _sfilename::String, _sflags::String="")
    @checked Lib.XPRSreadbasis(prob, _sfilename, _sflags)
end

"""

    writebasis(prob::XpressProblem, _sfilename, _sflags)

*Purpose*

Writes the current
basis to a file for later input into the Optimizer.

*Synopsis*

int XPRS_CC XPRSwritebasis(XPRSprob prob, const char *filename, const char *flags);

*Arguments*

`prob`: The current problem.
`filename`: A string of up to
`MAXPROBNAMELENGTH characters containing the file name from which the basis is to be written. If omitted, the default`: problem_name is used with a
`.bss extension.`: flags
`Flags to pass to`: XPRSwritebasis (
`WRITEBASIS):`: i
`output the internal presolved basis.`: t
`output a compact advanced form of the basis.`: n
`output basis file containing current solution values.`: h
`output values in single precision.`: x
`output values in hexadecimal format.`: p

*Example*

An equivalent set of commands to the above for console users would be:

*Related*

XPRSgetbasis,
XPRSreadbasis (
READBASIS).
"""
function writebasis(prob::XpressProblem, _sfilename::String, _sflags::String="")
    @checked Lib.XPRSwritebasis(prob, _sfilename, _sflags)
end

"""

    XPRSglobal(prob::XpressProblem)

*Purpose*

Starts the global
search for an integer solution after solving the LP relaxation with
XPRSmaxim (
MAXIM) or
XPRSminim (
MINIM) or continues a global search if it has been interrupted.
This function is deprecated and might be removed in a future release. XPRSmipoptimize should be used instead.

*Synopsis*

int XPRS_CC XPRSglobal(XPRSprob prob);

*Arguments*

`prob`: The current problem.

*Example*

The equivalent set of commands for the Console Optimizer are:

*Related*

XPRSfixglobals (
FIXGLOBALS),
XPRSinitglobal,
XPRSmaxim (
MAXIM)/
XPRSminim (
MINIM),
The Simplex Log.
"""
function XPRSglobal(prob::XpressProblem)
    @checked Lib.XPRSglobal(prob)
end

"""

    initglobal(prob::XpressProblem)

*Purpose*

Reinitializes the
global tree search. By default if a global search is interrupted and called again the global search will continue from where it left off. If
XPRSinitglobal is called after the first call to
XPRSmipoptimize, the global search will start from the top node when
XPRSmipoptimize is called again.
This function is deprecated and might be removed in a future release. XPRSpostsolve should be used instead.

*Synopsis*

int XPRS_CC XPRSinitglobal(XPRSprob prob);

*Arguments*

`prob`: The current problem.

*Example*

The following initializes the global search before attempting to solve the problem again:

*Related*

XPRSmipoptimize (
MIPOPTIMIZE).
"""
function initglobal(prob::XpressProblem)
    @checked Lib.XPRSinitglobal(prob)
end

"""

    writeprtsol(prob::XpressProblem, _sfilename, _sflags)

*Purpose*

Writes the current
solution to a
fixed format ASCII file,
problem_name
.prt.

*Synopsis*

int XPRS_CC XPRSwriteprtsol(XPRSprob prob, const char *filename, const char *flags);

*Arguments*

`prob`: The current problem.
`filename`: A string of up to
`MAXPROBNAMELENGTH characters containing the file name to which the solution is to be written. If omitted, the default`: problem_name will be used. The extension
`.prt will be appended.`: flags
`Flags for`: XPRSwriteprtsol (
`WRITEPRTSOL) are:`: x

*Example*

READPROB
LPOPTIMIZE
PRINTSOL

*Related*

XPRSgetlpsol,
XPRSgetmipsol,
XPRSreadbinsol
XPRSwritebinsol,
XPRSwriteprtrange,
XPRSwritesol,
ASCII Solution Files.
"""
function writeprtsol(prob::XpressProblem, _sfilename::String, _sflags::String="")
    @checked Lib.XPRSwriteprtsol(prob, _sfilename, _sflags)
end

"""

    alter(prob::XpressProblem, _sfilename)

*Purpose*

Alters or changes
matrix elements, right hand sides and
constraint senses in the current problem.

*Synopsis*

int XPRS_CC XPRSalter(XPRSprob prob, const char *filename);

*Arguments*

`prob`: The current problem.
`filename`: A string of up to
`MAXPROBNAMELENGTH characters specifying the file to be read. If omitted, the default`: problem_name is used with a

*Example*

The following example reads in the file
fred.alt, from which instructions are taken to alter the current matrix:

*Related*

Section
The Matrix Alteration (.alt) File.
"""
function alter(prob::XpressProblem, _sfilename::String)
    @checked Lib.XPRSalter(prob, _sfilename)
end

"""

    writesol(prob::XpressProblem, _sfilename, _sflags)

*Purpose*

Writes the current
solution to a
CSV format ASCII file,
problem_name
.asc (and
.hdr).

*Synopsis*

int XPRS_CC XPRSwritesol(XPRSprob prob, const char *filename, const char *flags);

*Arguments*

`prob`: The current problem.
`filename`: A string of up to
`MAXPROBNAMELENGTH characters containing the file name to which the solution is to be written. If omitted, the default`: problem_name will be used. The extensions
`.hdr and`: .asc will be appended.
`flags`: Flags to control which optional fields are output:
`s`: sequence number;
`n`: name;
`t`: type;
`b`: basis status;
`a`: activity;
`c`: cost (columns), slack (rows);
`l`: lower bound;
`u`: upper bound;
`d`: dj (column; reduced costs), dual value (rows; shadow prices);
`r`: right hand side (rows).
`If no flags are specified, all fields are output.`: Additional flags:
`e`: outputs every MIP or goal programming solution saved;
`p`: outputs in full precision;
`q`: only outputs vectors with nonzero optimum value;
`x`: output the current LP solution instead of the MIP solution.

*Example*

Suppose we wish to produce files containing
the names and values of variables starting with the letter X which are nonzero and
the names, values and right hand sides of constraints starting with CO2.
The Optimizer commands necessary to do this are:

*Related*

XPRSgetlpsol,
XPRSgetmipsol,
XPRSwriterange (
WRITERANGE),
XPRSwriteprtsol (
WRITEPRTSOL).
"""
function writesol(prob::XpressProblem, _sfilename::String, _sflags="")
    @checked Lib.XPRSwritesol(prob, _sfilename, _sflags)
end

"""

    writebinsol(prob::XpressProblem, _sfilename, _sflags)

*Purpose*

Writes the current MIP or LP solution to a binary solution file for later input into the Optimizer.

*Synopsis*

int XPRS_CC XPRSwritebinsol(XPRSprob prob, const char *filename, const char *flags);

*Arguments*

`prob`: The current problem.
`filename`: A string of up to
`MAXPROBNAMELENGTH characters containing the file name to which the solution is to be written. If omitted, the default`: problem_name is used with a
`.sol extension.`: flags
`Flags to pass to`: XPRSwritebinsol (
`WRITEBINSOL):`: x

*Example*

An equivalent set of commands to the above for console users would be:

*Related*

XPRSgetlpsol,
XPRSgetmipsol,
XPRSreadbinsol (
READBINSOL),
XPRSwritesol (
WRITESOL),
XPRSwriteprtsol (
WRITEPRTSOL).
"""
function writebinsol(prob::XpressProblem, _sfilename::String, _sflags)
    @checked Lib.XPRSwritebinsol(prob, _sfilename, _sflags)
end

"""

    readbinsol(prob::XpressProblem, _sfilename, _sflags)

*Purpose*

Reads a solution from a binary solution file.

*Synopsis*

int XPRS_CC XPRSreadbinsol(XPRSprob prob, const char *filename, const char *flags);

*Arguments*

`prob`: The current problem.
`filename`: A string of up to
`MAXPROBNAMELENGTH characters containing the file name from which the solution is to be read. If omitted, the default`: problem_name is used with a
`.sol extension.`: flags
`Flags to pass to`: XPRSreadbinsol (
`READBINSOL):`: m

*Example*

An equivalent set of commands to the above for console users would be:

*Related*

XPRSgetlpsol,
XPRSgetmipsol,
XPRSwritebinsol (
WRITEBINSOL),
XPRSwritesol (
WRITESOL),
XPRSwriteprtsol (
WRITEPRTSOL).
"""
function readbinsol(prob::XpressProblem, _sfilename::String, _sflags)
    @checked Lib.XPRSreadbinsol(prob, _sfilename, _sflags)
end

"""

    writeslxsol(prob::XpressProblem, _sfilename, _sflags)

*Purpose*

Creates an ASCII solution file (
.slx) using a similar format to MPS files. These files can be read back into the Optimizer using the
XPRSreadslxsol function.

*Synopsis*

int XPRS_CC XPRSwriteslxsol(XPRSprob prob, const char *filename, const char *flags);

*Arguments*

`prob`: The current problem.
`filename`: A string of up to
`MAXPROBNAMELENGTH characters containing the file name to which the solution is to be written. If omitted, the default`: problem_name is used with a
`.slx extension.`: flags
`Flags to pass to`: XPRSwriteslxsol (
`WRITESLXSOL):`: l
`write the LP solution in case of a MIP problem;`: m
`write the MIP solution;`: p
`use full precision for numerical values;`: x
`use hexadecimal format to write values;`: d
`LP solution only: including dual variables;`: s
`LP solution only: including slack variables;`: r

*Example*

WRITESLXSOL lpsolution

*Related*

XPRSreadslxsol (
READSLXSOL,
XPRSwriteprtsol (
WRITEPRTSOL),
XPRSwritebinsol (
WRITEBINSOL),
XPRSreadbinsol (
READBINSOL).
"""
function writeslxsol(prob::XpressProblem, _sfilename::String, _sflags)
    @checked Lib.XPRSwriteslxsol(prob, _sfilename, _sflags)
end

"""

    readslxsol(prob::XpressProblem, _sfilename, _sflags)

*Purpose*

Reads an ASCII solution file (
.slx) created by the
XPRSwriteslxsol function.

*Synopsis*

int XPRS_CC XPRSreadslxsol(XPRSprob prob, const char *filename, const char *flags);

*Arguments*

`prob`: The current problem.
`filename`: A string of up to
`MAXPROBNAMELENGTH characters containing the file name to which the solution is to be read. If omitted, the default`: problem_name is used with a
`.slx extension.`: flags
`Flags to pass to`: XPRSwriteslxsol (
`WRITESLXSOL):`: l
`read the solution as an LP solution in case of a MIP problem;`: m
`read the solution as a solution for the MIP problem;`: a
`reads multiple MIP solutions from the`: .slx file and adds them to the MIP problem;

*Example*

READSLXSOL lpsolution

*Related*

XPRSreadbinsol (
READBINSOL),
XPRSwriteslxsol (
WRITESLXSOL),
XPRSwritebinsol
WRITEBINSOL,
XPRSreadbinsol (
READBINSOL),
XPRSaddmipsol,
XPRSaddcbusersolnotify.
"""
function readslxsol(prob::XpressProblem, _sfilename::String, _sflags)
    @checked Lib.XPRSreadslxsol(prob, _sfilename, _sflags)
end

"""

    writeprtrange(prob::XpressProblem)

*Purpose*

Writes the ranging information to a
fixed format ASCII file,
problem_name
.rrt. The binary range file (
.rng) must already exist, created by
XPRSrange
(
RANGE).

*Synopsis*

int XPRS_CC XPRSwriteprtrange(XPRSprob prob);

*Arguments*

`prob`: The current problem.

*Example*

An equivalent set of commands for the Console user would be:

*Related*

XPRSgetcolrange,
XPRSgetrowrange,
XPRSrange (
RANGE),
XPRSwriteprtsol,
XPRSwriterange,
The Directives (.dir) File.
"""
function writeprtrange(prob::XpressProblem)
    @checked Lib.XPRSwriteprtrange(prob)
end

"""

    writerange(prob::XpressProblem, _sfilename, _sflags)

*Purpose*

Writes the ranging information to a
CSV format ASCII file,
problem_name
.rsc (and
.hdr). The binary range file (
.rng) must already exist, created by
XPRSrange (
RANGE) and an associated header file.

*Synopsis*

int XPRS_CC XPRSwriterange(XPRSprob prob, const char *filename, const char *flags);

*Arguments*

`prob`: The current problem.
`filename`: A string of up to
`MAXPROBNAMELENGTH characters containing the file name to which the ranging information is to be written. If omitted, the default`: problem_name will be used. The extensions
`.hdr and`: .rsc will be appended to the filename.
`flags`: Flags to control which optional fields are output:
`s`: sequence number;
`n`: name;
`t`: type;
`b`: basis status;
`a`: activity;
`c`: cost (column), slack (row).

*Example*

RANGE
WRITERANGE -nbac

*Related*

XPRSgetlpsol,
XPRSgetmipsol,
XPRSwriteprtrange (
WRITEPRTRANGE),
XPRSrange (
RANGE),
XPRSwritesol (
WRITESOL),
The Directives (.dir) File.
"""
function writerange(prob::XpressProblem, _sfilename::String, _sflags)
    @checked Lib.XPRSwriterange(prob, _sfilename, _sflags)
end

function getsol(prob::XpressProblem, _dx, _dslack, _dual, _dj)
    @checked Lib.XPRSgetsol(prob, _dx, _dslack, _dual, _dj)
end

"""

    getpresolvesol(prob::XpressProblem, _dx, _dslack, _dual, _dj)

*Purpose*

Returns the solution for the presolved problem from memory.

*Synopsis*

int XPRS_CC XPRSgetpresolvesol(XPRSprob prob, double x[], double slack[], double dual[], double dj[]);

*Arguments*

`prob`: The current problem.
`x`: Double array of length
`COLS where the values of the primal variables will be returned. May be`: NULL if not required.
`slack`: Double array of length
`ROWS where the values of the slack variables will be returned. May be`: NULL if not required.
`dual`: Double array of length
`ROWS where the values of the dual variables will be returned. May be`: NULL if not required.
`dj`: Double array of length
`COLS where the reduced cost for each variable will be returned. May be`: NULL if not required.

*Example*

The following reads in a (Mixed) Integer Programming problem and displays the solution to the presolved problem following optimization of the linear relaxation:

*Related*

XPRSgetlpsol,
Working with Presolve.
"""
function getpresolvesol(prob::XpressProblem, _dx, _dslack, _dual, _dj)
    @checked Lib.XPRSgetpresolvesol(prob, _dx, _dslack, _dual, _dj)
end

"""

    getinfeas(prob::XpressProblem, npv, nps, nds, ndv, mx, mslack, mdual, mdj)

*Purpose*

Returns a list of infeasible primal and dual
variables.

*Synopsis*

int XPRS_CC XPRSgetinfeas(XPRSprob prob, int *npv, int *nps, int *nds, int *ndv, int mx[], int mslack[], int mdual[], int mdj[]);

*Arguments*

`prob`: The current problem.
`npv`: Pointer to an integer where the number of primal infeasible variables is returned.
`nps`: Pointer to an integer where the number of primal infeasible rows is returned.
`nds`: Pointer to an integer where the number of dual infeasible rows is returned.
`ndv`: Pointer to an integer where the number of dual infeasible variables is returned.
`mx`: Integer array of length
`npv where the primal infeasible variables will be returned. May be`: NULL if not required.
`mslack`: Integer array of length
`nps where the primal infeasible rows will be returned. May be`: NULL if not required.
`mdual`: Integer array of length
`nds where the dual infeasible rows will be returned. May be`: NULL if not required.
`mdj`: Integer array of length
`ndv where the dual infeasible variables will be returned. May be`: NULL if not required.

*Example*

In this example,
XPRSgetinfeas is first called with nulled integer arrays to get the number of infeasible entries. Then space is allocated for the arrays and the function is again called to fill them in:

*Related*

XPRSgetscaledinfeas,
XPRSgetiisdata,
XPRSiisall,
XPRSiisclear,
XPRSiisfirst,
XPRSiisisolations,
XPRSiisnext,
XPRSiisstatus,
XPRSiiswrite,
IIS.
"""
function getinfeas(prob::XpressProblem, npv, nps, nds, ndv, mx, mslack, mdual, mdj)
    @checked Lib.XPRSgetinfeas(prob, npv, nps, nds, ndv, mx, mslack, mdual, mdj)
end

"""

    getscaledinfeas(prob::XpressProblem, npv, nps, nds, ndv, mx, mslack, mdual, mdj)

*Purpose*

Returns a list of scaled infeasible primal and dual
variables for the original problem. If the problem is currently
presolved, it is postsolved before the function returns.

*Synopsis*

int XPRS_CC XPRSgetscaledinfeas(XPRSprob prob, int *npv, int *nps, int *nds, int *ndv, int mx[], int mslack[], int mdual[], int mdj[]);

*Arguments*

`prob`: The current problem.
`npv`: Number of primal infeasible variables.
`nps`: Number of primal infeasible rows.
`nds`: Number of dual infeasible rows.
`ndv`: Number of dual infeasible variables.
`mx`: Integer array of length
`npv where the primal infeasible variables will be returned. May be`: NULL if not required.
`mslack`: Integer array of length
`nps where the primal infeasible rows will be returned. May be`: NULL if not required.
`mdual`: Integer array of length
`nds where the dual infeasible rows will be returned. May be`: NULL if not required.
`mdj`: Integer array of length
`ndv where the dual infeasible variables will be returned. May be`: NULL if not required.

*Example*

In this example,
XPRSgetscaledinfeas is first called with nulled integer arrays to get the number of infeasible entries. Then space is allocated for the arrays and the function is again called to fill them in.

*Related*

XPRSgetinfeas,
XPRSgetiisdata,
XPRSiisall,
XPRSiisclear,
XPRSiisfirst,
XPRSiisisolations,
XPRSiisnext,
XPRSiisstatus,
XPRSiiswrite,
IIS.
"""
function getscaledinfeas(prob::XpressProblem, npv, nps, nds, ndv, mx, mslack, mdual, mdj)
    @checked Lib.XPRSgetscaledinfeas(prob, npv, nps, nds, ndv, mx, mslack, mdual, mdj)
end

"""

    getunbvec(prob::XpressProblem, icol)

*Purpose*

Returns the index vector which causes the primal simplex or dual simplex algorithm to determine that a matrix is primal or dual
unbounded respectively.

*Synopsis*

int XPRS_CC XPRSgetunbvec(XPRSprob prob, int *junb);

*Arguments*

`prob`: The current problem.
`junb`: Pointer to an integer where the vector causing the problem to be detected as being primal or dual unbounded will be returned. In the dual simplex case, the vector is the leaving row for which the dual simplex detected dual unboundedness. In the primal simplex case, the vector is the entering row
`junb (if`: junb is in the range
`0 to`: ROWS
`-1) or column (variable)`: junb-ROWS-
`SPAREROWS (if`: junb is between
`ROWS+SPAREROWS and`: ROWS+SPAREROWS+
`COLS`: -1) for which the primal simplex detected primal unboundedness.

*Example*



*Related*

XPRSgetinfeas,
XPRSlpoptimize.
"""
function getunbvec(prob::XpressProblem, icol)
    @checked Lib.XPRSgetunbvec(prob, icol)
end

"""

    btran(prob::XpressProblem, dwork)

*Purpose*

Post-multiplies a (row) vector provided by the user by the inverse of the current basis.

*Synopsis*

int XPRS_CC XPRSbtran(XPRSprob prob, double vec[]);

*Arguments*

`prob`: The current problem.
`vec`: Double array of length

*Example*

Get the (unscaled) tableau row
z of constraint number
irow, assuming that all arrays have been dimensioned.

*Related*

XPRSftran.
"""
function btran(prob::XpressProblem, dwork)
    @checked Lib.XPRSbtran(prob, dwork)
end

"""

    ftran(prob::XpressProblem, dwork)

*Purpose*

Pre-multiplies a (column) vector provided by the user by the inverse of the current matrix.

*Synopsis*

int XPRS_CC XPRSftran(XPRSprob prob, double vec[]);

*Arguments*

`prob`: The current problem.
`vec`: Double array of length

*Example*

To get the (unscaled) tableau column of structural variable number
jcol, assuming that all arrays have been dimensioned, do the following:

*Related*

XPRSbtran.
"""
function ftran(prob::XpressProblem, dwork)
    @checked Lib.XPRSftran(prob, dwork)
end

"""

    getobj(prob::XpressProblem, _dobj, first, last)

*Purpose*

Returns the
objective function coefficients for the columns in a given range.

*Synopsis*

int XPRS_CC XPRSgetobj(XPRSprob prob, double obj[], int first, int last);

*Arguments*

`prob`: The current problem.
`obj`: Double array of length
`last-first+1 where the objective function coefficients are to be placed.`: first
`First column in the range.`: last

*Example*

The following example retrieves the objective function coefficients of the current problem:

*Related*

XPRSchgobj.
"""
function getobj(prob::XpressProblem)
    ncols = n_variables(prob)
    first = 0
    last = ncols - 1
    _dobj = Vector{Float64}(undef, ncols)
    @checked Lib.XPRSgetobj(prob, _dobj, first, last)
    return _dobj
end

"""

    getrhs(prob::XpressProblem, _drhs, first, last)

*Purpose*

Returns the
right hand side elements for the rows in a given range.

*Synopsis*

int XPRS_CC XPRSgetrhs(XPRSprob prob, double rhs[], int first, int last);

*Arguments*

`prob`: The current problem.
`rhs`: Double array of length
`last-first+1 where the right hand side elements are to be placed.`: first
`First row in the range.`: last

*Example*

The following example retrieves the right hand side values of the problem:

*Related*

XPRSchgrhs,
XPRSchgrhsrange,
XPRSgetrhsrange.
"""
function getrhs(prob::XpressProblem, first::Integer=1, last::Integer=0)
    n_elems = last - first + 1
    if n_elems <= 0
        n_elems = n_constraints(prob)
        first = 0
        last = n_elems - 1
    else
        first = first - 1
        last = last - 1
    end
    _drhs = Vector{Float64}(undef, n_elems)
    @checked Lib.XPRSgetrhs(prob, _drhs, first, last)
    return _drhs
end

"""

    getrhsrange(prob::XpressProblem, _drng, first, last)

*Purpose*

Returns the
right hand side range values for the rows in a given range.

*Synopsis*

int XPRS_CC XPRSgetrhsrange(XPRSprob prob, double range[], int first, int last);

*Arguments*

`prob`: The current problem.
`range`: Double array of length
`last-first+1 where the right hand side range values are to be placed.`: first
`First row in the range.`: last

*Example*

The following returns right hand side range values for all rows in the matrix:

*Related*

XPRSchgrhs,
XPRSchgrhsrange,
XPRSgetrhs,
XPRSrange.
"""
function getrhsrange(prob::XpressProblem, _drng, first::Integer, last::Integer)
    @checked Lib.XPRSgetrhsrange(prob, _drng, first, last)
end

"""

    getlb(prob::XpressProblem, _dbdl, first, last)

*Purpose*

Returns the lower
bounds for the
columns in a given range.

*Synopsis*

int XPRS_CC XPRSgetlb(XPRSprob prob, double lb[], int first, int last);

*Arguments*

`prob`: The current problem.
`lb`: Double array of length
`last-first+1 where the lower bounds are to be placed.`: first
`First column in the range.`: last

*Example*

The following example retrieves the lower bounds for the columns of the current problem:

*Related*

XPRSchgbounds,
XPRSgetub.
"""
function getlb(prob::XpressProblem, first::Integer=1, last::Integer=0)
    n_elems = last - first + 1
    if n_elems <= 0
        n_elems = n_variables(prob)
        first = 0
        last = n_elems - 1
    else
        first = first - 1
        last = last - 1
    end
    _dbdl = Vector{Float64}(undef, n_elems)
    @checked Lib.XPRSgetlb(prob, _dbdl, first, last)
    return _dbdl
end

"""

    getub(prob::XpressProblem, _dbdu, first, last)

*Purpose*

Returns the upper
bounds for the columns in a given range.

*Synopsis*

int XPRS_CC XPRSgetub(XPRSprob prob, double ub[], int first, int last);

*Arguments*

`prob`: The current problem.
`ub`: Double array of length
`last-first+1 where the upper bounds are to be placed.`: first
`First column in the range.`: last

*Example*

The following example retrieves the upper bounds for the columns of the current problem:

*Related*

XPRSchgbounds,
XPRSgetlb.
"""
function getub(prob::XpressProblem, first::Integer=1, last::Integer=0)
    n_elems = last - first + 1
    if n_elems <= 0
        n_elems = n_variables(prob)
        first = 0
        last = n_elems - 1
    else
        first = first - 1
        last = last - 1
    end
    _dbdu = Vector{Float64}(undef, n_elems)
    @checked Lib.XPRSgetub(prob, _dbdu, first, last)
    return _dbdu
end

"""

    getcols(prob::XpressProblem, _mstart, _mrwind, _dmatval, maxcoeffs, ncoeffs, first, last)

*Purpose*

Returns the nonzeros in the constraint
matrix for the
columns in a given range.

*Synopsis*

int XPRS_CC XPRSgetcols(XPRSprob prob, int mstart[], int mrwind[], double dmatval[], int size, int *nels, int first, int last);

*Arguments*

`prob`: The current problem.
`mstart`: Integer array which will be filled with the indices indicating the starting offsets in the
`mrwind and`: dmatval arrays for each requested column. It must be of length at least
`last-first+2. Column`: i starts at position
`mstart[i] in the`: mrwind and
`dmatval arrays, and has`: mstart[i+1]-mstart[i] elements in it. May be
`NULL if not required.`: mrwind
`Integer array of length`: size which will be filled with the row indices of the nonzero coefficents for each column. May be
`NULL if not required.`: dmatval
`Double array of length`: size which will be filled with the nonzero coefficient values. May be
`NULL if not required.`: size
`The size of the`: mrwind and
`dmatval arrays. This is the maximum number of nonzero coefficients that the Optimizer is allowed to return.`: nels
`Pointer to an integer where the number of nonzero coefficients in the selected columns will be returned. If`: nels exceeds
`size, only the`: size first nonzero coefficients will be returned.
`first`: First column in the range.
`last`: Last column in the range.

*Example*

The following examples retrieves the number of nonzero coefficients in all columns of the problem:

*Related*

XPRSgetrows.
"""
function getcols(prob::XpressProblem, _mstart, _mrwind, _dmatval, maxcoeffs, ncoeffs, first::Integer, last::Integer)
    @checked Lib.XPRSgetcols(prob, _mstart, _mrwind, _dmatval, maxcoeffs, ncoeffs, first, last)
end

function getcols64(prob::XpressProblem, _mstart, _mrwind, _dmatval, maxcoeffs, ncoeffs, first::Integer, last::Integer)
    @checked Lib.XPRSgetcols64(prob, _mstart, _mrwind, _dmatval, maxcoeffs, ncoeffs, first, last)
end

"""

    getrows(prob::XpressProblem, _mstart, _mclind, _dmatval, maxcoeffs, ncoeffs, first, last)

*Purpose*

Returns the
nonzeros in the constraint matrix for the rows in a given range.

*Synopsis*

int XPRS_CC XPRSgetrows(XPRSprob prob, int mstart[], int mclind[], double dmatval[], int size, int *nels, int first, int last);

*Arguments*

`prob`: The current problem.
`mstart`: Integer array which will be filled with the indices indicating the starting offsets in the
`mrwind and`: dmatval arrays for each requested row. It must be of length at least
`last-first+2. Row`: i starts at position
`mstart[i] in the`: mrwind and
`dmatval arrays, and has`: mstart[i+1]-mstart[i] elements in it. May be
`NULL if not required.`: mrwind
`Integer arrays of length`: size which will be filled with the column indices of the nonzero elements for each row. May be
`NULL if not required.`: dmatval
`Double array of length`: size which will be filled with the nonzero element values. May be
`NULL if not required.`: size
`Maximum number of elements to be retrieved.`: nels
`Pointer to the integer where the number of nonzero elements in the`: mrwind and
`dmatval arrays will be returned. If the number of nonzero elements is greater that`: size, then only
`size elements will be returned. If`: nels is smaller that
`size, then only`: nels will be returned.
`first`: First row in the range.
`last`: Last row in the range.

*Example*

The following example returns and displays at most six nonzero matrix entries in the first two rows:

*Related*

XPRSgetcols,
XPRSgetrowrange,
XPRSgetrowtype.
"""
function getrows(prob::XpressProblem, _mstart, _mclind, _dmatval, maxcoeffs, first::Integer, last::Integer)
    @checked Lib.XPRSgetrows(prob, _mstart, _mclind, _dmatval, maxcoeffs, C_NULL, first - 1, last - 1)
    _mstart .+= 1
    _mclind .+= 1
    return
end

function getrows_nnz(prob::XpressProblem, first::Integer, last::Integer)
    nzcnt = zeros(Cint, 1)
    @checked Lib.XPRSgetrows(prob, C_NULL, C_NULL, C_NULL, 0, nzcnt, first - 1, last - 1)
    return nzcnt[]
end

# TODO
function getrows64(prob::XpressProblem, _mstart, _mclind, _dmatval, maxcoeffs, first::Integer, last::Integer)
    @checked Lib.XPRSgetrows64(prob, _mstart .- 1, _mclind .- 1, _dmatval, maxcoeffs, C_NULL, first - 1, last - 1)
end

"""

    getcoef(prob::XpressProblem, _irow, _icol, _dval)

*Purpose*

Returns a single coefficient in the constraint matrix.

*Synopsis*

int XPRS_CC XPRSgetcoef(XPRSprob prob, int irow, int icol, double *dval);

*Arguments*

`prob`: The current problem.
`irow`: Row of the constraint matrix.
`icol`: Column of the constraint matrix.
`dval`: Pointer to a double where the coefficient will be returned.

*Example*



*Related*

XPRSgetcols,
XPRSgetrows.
"""
function getcoef(prob::XpressProblem, _irow, _icol, _dval)
    @checked Lib.XPRSgetcoef(prob, _irow, _icol, _dval)
end

"""

    getmqobj(prob::XpressProblem, _mstart, _mclind, _dobjval, maxcoeffs, ncoeffs, first, last)

*Purpose*

Returns the nonzeros in the quadratic objective coefficients matrix for the columns in a given range. To achieve maximum efficiency,
XPRSgetmqobj returns the lower triangular part of this matrix only.

*Synopsis*

int XPRS_CC XPRSgetmqobj (XPRSprob prob, int mstart[], int mclind[], double dobjval[], int size, int *nels, int first, int last);

*Arguments*

`prob`: The current problem.
`mstart`: Integer array which will be filled with indices indicating the starting offsets in the
`mclind and`: dobjval arrays for each requested column. It must be length of at least
`last-first+2. Column`: i starts at position
`mstart[i] in the`: mrwind and
`dmatval arrays, and has`: mstart[i+1]-mstart[i] elements in it. May be NULL if
`size is`: 0.
`mclind`: Integer array of length
`size which will be filled with the column indices of the nonzero elements in the lower triangular part of`: Q. May be
`NULL if`: size is
`0.`: dobjval
`Double array of length`: size which will be filled with the nonzero element values. May be
`NULL if`: size is
`0.`: size
`The maximum number of elements to be returned (size of the arrays).`: nels
`Pointer to an integer where the number of nonzero quadratic objective coefficients will be returned. If the number of nonzero coefficients is greater than`: size, then only
`size elements will be returned. If`: nels is smaller than
`size, then only`: nels will be returned.
`first`: First column in the range.
`last`: Last column in the range.

*Example*



*Related*

XPRSchgmqobj,
XPRSchgqobj,
XPRSgetqobj.
"""
function getmqobj(prob::XpressProblem, _mstart, _mclind, _dobjval, maxcoeffs, ncoeffs, first::Integer, last::Integer)
    @checked Lib.XPRSgetmqobj(prob, _mstart, _mclind, _dobjval, maxcoeffs, ncoeffs, first, last)
end

function getmqobj64(prob::XpressProblem, _mstart, _mclind, _dobjval, maxcoeffs, ncoeffs, first::Integer, last::Integer)
    @checked Lib.XPRSgetmqobj64(prob, _mstart, _mclind, _dobjval, maxcoeffs, ncoeffs, first, last)
end

"""

    crossoverlpsol(prob::XpressProblem, status)

*Purpose*

Provides a basic optimal solution for a given solution of an LP problem. This function behaves like the crossover after the barrier algorithm.

*Synopsis*

int XPRS_CC XPRScrossoverlpsol(XPRSprob prob, int *status);

*Arguments*

`prob`: The current problem.
`status`: Pointer to an
`int where the status will be returned. The status is one of:`: 0
`The crossover is successful.`: 1

*Example*

This example loads a problem, loads a solution for the problem and then uses
XPRScrossoverlpsol to find a basic optimal solution.

*Related*

XPRSloadlpsol,
XPRSreadslxsol, Section
Crossover.
"""
function crossoverlpsol(prob::XpressProblem, status)
    @checked Lib.XPRScrossoverlpsol(prob, status)
end

function getbarnumstability(prob::XpressProblem, dColumnStability, dRowStability)
    @checked Lib.XPRSgetbarnumstability(prob, dColumnStability, dRowStability)
end

"""

    iisclear(prob::XpressProblem)

*Purpose*

Resets the search for Irreducible Infeasible Sets (IIS).

*Synopsis*

int XPRS_CC XPRSiisclear(XPRSprob prob);

*Arguments*

`prob`: The current problem.

*Example*

XPRSiisclear(prob);

*Related*

XPRSgetiisdata,
XPRSiisall,
XPRSiisfirst,
XPRSiisisolations,
XPRSiisnext,
XPRSiisstatus,
XPRSiiswrite,
IIS.
"""
function iisclear(prob::XpressProblem)
    @checked Lib.XPRSiisclear(prob)
end

"""

    iisfirst(prob::XpressProblem, iismode, status_code)

*Purpose*

Initiates a search for an Irreducible Infeasible Set (IIS) in an infeasible problem.

*Synopsis*

int XPRS_CC XPRSiisfirst(XPRSprob prob, int iismode, int *status_code);

*Arguments*

`prob`: The current problem.
`iismode`: The IIS search mode:
`0`: stops after finding the initial infeasible subproblem;
`1`: find an IIS, emphasizing simplicity of the IIS;
`2`: find an IIS, emphasizing a quick result.
`status_code`: The status after the search:
`0`: success;
`1`: if problem is feasible;
`2`: error (when the function returns nonzero).

*Example*

This looks for the first IIS.

*Related*

XPRSgetiisdata,
XPRSiisall,
XPRSiisclear,
XPRSiisisolations,
XPRSiisnext,
XPRSiisstatus,
XPRSiiswrite,
IIS.
"""
function iisfirst(prob::XpressProblem, iismode, status_code)
    @checked Lib.XPRSiisfirst(prob, iismode, status_code)
end

"""

    iisnext(prob::XpressProblem, status_code)

*Purpose*

Continues the search for further Irreducible Infeasible Sets (IIS), or calls
XPRSiisfirst (
IIS) if no IIS has been identified yet.

*Synopsis*

int XPRS_CC XPRSiisnext(XPRSprob prob, int *status_code);

*Arguments*

`prob`: The current problem.
`status_code`: The status after the search:
`0`: success;
`1`: no more IIS could be found, or problem is feasible if no
`XPRSiisfirst call preceded;`: 2

*Example*

This looks for a further IIS.

*Related*

XPRSgetiisdata,
XPRSiisall,
XPRSiisclear,
XPRSiisfirst,
XPRSiisisolations,
XPRSiisstatus,
XPRSiiswrite,
IIS.
"""
function iisnext(prob::XpressProblem, status_code)
    @checked Lib.XPRSiisnext(prob, status_code)
end

"""

    iisstatus(prob::XpressProblem, iiscount, rowsizes, colsizes, suminfeas, numinfeas)

*Purpose*

Returns statistics on the Irreducible Infeasible Sets (IIS) found so far by
XPRSiisfirst (
IIS),
XPRSiisnext (
IIS
-n) or
XPRSiisall (
IIS
-a).

*Synopsis*

int XPRS_CC XPRSiisstatus(XPRSprob prob, int *iiscount, int rowsizes[], int colsizes[], double suminfeas[], int numinfeas[]);

*Arguments*

`prob`: The current problem.
`iiscount`: The number of IISs found so far.
`rowsizes`: Number of rows in the IISs.
`colsizes`: Number of bounds in the IISs.
`suminfeas`: The sum of infeasibilities in the IISs after the first phase simplex.
`numinfeas`: The number of infeasible variables in the IISs after the first phase simplex.

*Example*

This example first retrieves the number of IISs found so far, and then retrieves their main properties. Note that the arrays have size
count+1, since the first index is reserved for the initial infeasible subset.

*Related*

XPRSgetiisdata,
XPRSiisall,
XPRSiisclear,
XPRSiisfirst,
XPRSiisisolations,
XPRSiisnext,
XPRSiiswrite,
IIS.
"""
function iisstatus(prob::XpressProblem, iiscount, rowsizes, colsizes, suminfeas, numinfeas)
    @checked Lib.XPRSiisstatus(prob, iiscount, rowsizes, colsizes, suminfeas, numinfeas)
end

"""

    iisall(prob::XpressProblem)

*Purpose*

Performs an automated search for independent Irreducible Infeasible Sets (IIS) in an infeasible problem.

*Synopsis*

int XPRS_CC XPRSiisall(XPRSprob prob);

*Arguments*

`prob`: The current problem.

*Example*

This example searches for IISs and then questions the problem attribute
NUMIIS to determine how many were found:

*Related*

XPRSgetiisdata,
XPRSiisclear,
XPRSiisfirst,
XPRSiisisolations,
XPRSiisnext,
XPRSiisstatus,
XPRSiiswrite,
IIS.
"""
function iisall(prob::XpressProblem)
    @checked Lib.XPRSiisall(prob)
end

"""

    iiswrite(prob::XpressProblem, number, fn, filetype, typeflags)

*Purpose*

Writes an LP/MPS/CSV file containing a given Irreducible Infeasible Set (IIS). If 0 is passed as the IIS number parameter, the initial infeasible subproblem is written.

*Synopsis*

int XPRS_CC XPRSiiswrite(XPRSprob prob, int num, const char *fn, int type, const char *typeflags);

*Arguments*

`prob`: The current problem.
`num`: The ordinal number of the IIS to be written.
`fn`: The name of the file to be created.
`type`: Type of file to be created:
`0`: creates an lp/mps file containing the IIS as a linear programming problem;
`1`: creates a comma separated (csv) file containing the description and supplementary information on the given IIS.
`typeflags`: Flags passed to the

*Example*

This writes the first IIS (if one exists and is already found) as an lp file.

*Related*

XPRSgetiisdata,
XPRSiisall,
XPRSiisclear,
XPRSiisfirst,
XPRSiisisolations,
XPRSiisnext,
XPRSiisstatus,
IIS.
"""
function iiswrite(prob::XpressProblem, number, fn, filetype, typeflags)
    @checked Lib.XPRSiiswrite(prob, number, fn, filetype, typeflags)
end

"""

    iisisolations(prob::XpressProblem, number)

*Purpose*

Performs the isolation identification procedure for an Irreducible Infeasible Set (IIS).

*Synopsis*

int XPRS_CC XPRSiisisolations(XPRSprob prob, int num);

*Arguments*

`prob`: The current problem.
`num`: The number of the IIS identified by either
`XPRSiisfirst (`: IIS),
`XPRSiisnext (`: IIS
`-n) or`: XPRSiisall (
`IIS`: -a) in which the isolations should be identified.

*Example*

This example finds the first IIS and searches for the isolations in that IIS.

*Related*

XPRSgetiisdata,
XPRSiisall,
XPRSiisclear,
XPRSiisfirst,
XPRSiisnext,
XPRSiisstatus,
XPRSiiswrite,
IIS.
"""
function iisisolations(prob::XpressProblem, number)
    @checked Lib.XPRSiisisolations(prob, number)
end

"""

    getiisdata(prob::XpressProblem, number, rownumber, colnumber, miisrow, miiscol, constrainttype, colbndtype, duals, rdcs, isolationrows, isolationcols)

*Purpose*

Returns information for an Irreducible Infeasible Set: size, variables (row and column vectors) and conflicting sides of the variables, duals and reduced costs.

*Synopsis*

int XPRS_CC XPRSgetiisdata(XPRSprob prob, int num, int *rownumber, int *colnumber, int miisrow[], int miiscol[], char constrainttype[], char colbndtype[], double duals[], double rdcs[], char isolationrows[], char isolationcols[]);

*Arguments*

`prob`: The current problem.
`num`: The ordinal number of the IIS to get data for.
`rownumber`: Pointer to an integer where the number of rows in the IIS will be returned.
`colnumber`: Pointer to an integer where the number of bounds in the IIS will be returned.
`miisrow`: Indices of rows in the IIS. Can be NULL if not required.
`miiscol`: Indices of bounds (columns) in the IIS. Can be NULL if not required.
`constrainttype`: Sense of rows in the IIS:
`L`: for less or equal row;
`G`: for greater or equal row.
`E`: for an equality row (for a non LP IIS);
`1`: for a SOS1 row;
`2`: for a SOS2 row;
`I`: for an indicator row.
`Can be NULL if not required.`: colbndtype
`Sense of bound in the IIS:`: U
`for upper bound;`: L
`for lower bound.`: F
`for fixed columns (for a non LP IIS);`: B
`for a binary column;`: I
`for an integer column;`: P
`for a partial integer columns;`: S
`for a semi-continuous column;`: R
`for a semi-continuous integer column.`: Can be NULL if not required.
`duals`: The
`dual multipliers associated with the rows. Can be NULL if not required.`: rdcs
`The dual multipliers (reduced costs) associated with the bounds. Can be NULL if not required.`: isolationrows
`The isolation status of the rows:`: -1
`if isolation information is not available for row (run iis isolations);`: 0
`if row is not in isolation;`: 1
`if row is in isolation.`: Can be NULL if not required.
`isolationcols`: The isolation status of the bounds:
`-1`: if isolation information is not available for column (run iis isolations);
`0`: if column is not in isolation;
`1`: if column is in isolation. Can be NULL if not required.

*Example*

This example first retrieves the size of IIS 1, then gets the detailed information for the IIS.

*Related*

XPRSiisall,
XPRSiisclear,
XPRSiisfirst,
XPRSiisisolations,
XPRSiisnext,
XPRSiisstatus,
XPRSiiswrite,
IIS, Section
IIS description file in CSV format.
"""
function getiisdata(prob::XpressProblem, number, rownumber, colnumber, miisrow, miiscol, constrainttype, colbndtype, duals, rdcs, isolationrows, isolationcols)
    @checked Lib.XPRSgetiisdata(prob, number, rownumber, colnumber, miisrow, miiscol, constrainttype, colbndtype, duals, rdcs, isolationrows, isolationcols)
end

function getiis(prob::XpressProblem, ncols, nrows, _miiscol, _miisrow)
    @checked Lib.XPRSgetiis(prob, ncols, nrows, _miiscol, _miisrow)
end

"""

    getpresolvebasis(prob::XpressProblem, _mrowstatus, _mcolstatus)

*Purpose*

Returns the current
basis from memory into the user's data areas. If the problem is presolved, the presolved basis will be returned. Otherwise the original basis will be returned.

*Synopsis*

int XPRS_CC XPRSgetpresolvebasis(XPRSprob prob, int rstatus[], int cstatus[]);

*Arguments*

`prob`: The current problem.
`rstatus`: Integer array of length
`ROWS to the basis status of the stack, surplus or artificial variable associated with each row. The status will be one of:`: 0
`slack, surplus or artificial is non-basic at lower bound;`: 1
`slack, surplus or artificial is basic;`: 2
`slack or surplus is non-basic at upper bound.`: May be
`NULL if not required.`: cstatus
`Integer array of length`: COLS to hold the basis status of the columns in the constraint matrix. The status will be one of:
`0`: variable is non-basic at lower bound, or superbasic at zero if the variable has no lower bound;
`1`: variable is basic;
`2`: variable is at upper bound;
`3`: variable is super-basic.
`May be`: NULL if not required.

*Example*

The following obtains and outputs basis information on a presolved problem prior to the global search:

*Related*

XPRSgetbasis,
XPRSloadbasis,
XPRSloadpresolvebasis.
"""
function getpresolvebasis(prob::XpressProblem, _mrowstatus, _mcolstatus)
    @checked Lib.XPRSgetpresolvebasis(prob, _mrowstatus, _mcolstatus)
end

"""

    loadpresolvebasis(prob::XpressProblem, _mrowstatus, _mcolstatus)

*Purpose*

Loads a
presolved
basis from the user's areas.

*Synopsis*

int XPRS_CC XPRSloadpresolvebasis(XPRSprob prob, const int rstatus[], const int cstatus[]);

*Arguments*

`prob`: The current problem.
`rstatus`: Integer array of length
`ROWS containing the basis status of the slack, surplus or artificial variable associated with each row. The status must be one of:`: 0
`slack, surplus or artificial is non-basic at lower bound;`: 1
`slack, surplus or artificial is basic;`: 2
`slack or surplus is non-basic at upper bound.`: cstatus
`Integer array of length`: COLS containing the basis status of each of the columns in the matrix. The status must be one of:
`0`: variable is non-basic at lower bound or superbasic at zero if the variable has no lower bound;
`1`: variable is basic;
`2`: variable is at upper bound;
`3`: variable is super-basic.

*Example*

The following example saves the presolved basis for one problem, loading it into another:

*Related*

XPRSgetbasis,
XPRSgetpresolvebasis,
XPRSloadbasis.
"""
function loadpresolvebasis(prob::XpressProblem, _mrowstatus, _mcolstatus)
    @checked Lib.XPRSloadpresolvebasis(prob, _mrowstatus, _mcolstatus)
end

"""

    getglobal(prob::XpressProblem, ngents, nsets, _sgtype, _mgcols, _dlim, _sstype, _msstart, _mscols, _dref)

*Purpose*

Retrieves
global information about a problem. It must be called before
XPRSmipoptimize if the presolve option is used.

*Synopsis*

int XPRS_CC XPRSgetglobal(XPRSprob prob, int *nglents, int *sets, char qgtype[], int mgcols[], double dlim[], char qstype[], int msstart[], int mscols[], double dref[]);

*Arguments*

`prob`: The current problem.
`nglents`: Pointer to the integer where the number of binary, integer, semi-continuous, semi-continuous integer and partial integer entities will be returned. This is equal to the problem attribute
`MIPENTS.`: sets
`Pointer to the integer where the number of SOS1 and SOS2 sets will be returned. It can be retrieved from the problem attribute`: SETS.
`qgtype`: Character array of length
`nglents where the entity types will be returned. The types will be one of:`: B
`binary variables;`: I
`integer variables;`: P
`partial integer variables;`: S
`semi-continuous variables;`: R
`semi-continuous integer variables.`: mgcols
`Integer array of length`: nglents where the column indices of the global entities will be returned.
`dlim`: Double array of length
`nglents where the limits for the partial integer variables and lower bounds for the semi-continuous and semi-continuous integer variables will be returned (any entries in the positions corresponding to binary and integer variables will be meaningless).`: qstype
`Character array of length`: sets where the set types will be returned. The set types will be one of:
`1`: SOS1 type sets;
`2`: SOS2 type sets.
`msstart`: Integer array where the offsets into the
`mscols and`: dref arrays indicating the start of the sets will be returned. This array must be of length
`sets+1, the final element will contain the offset where set`: sets+1 would start and equals the length of the
`mscols and`: dref arrays,
`SETMEMBERS.`: mscols
`Integer array of length`: SETMEMBERS where the columns in each set will be returned.
`dref`: Double array of length

*Example*

The following obtains the global variables and their types in the arrays
mgcols and
qrtype:

*Related*

XPRSloadglobal,
XPRSloadqglobal.
"""
function getglobal(prob::XpressProblem, ngents, nsets, _sgtype, _mgcols, _dlim, _sstype, _msstart, _mscols, _dref)
    @checked Lib.XPRSgetglobal(prob, ngents, nsets, _sgtype, _mgcols, _dlim, _sstype, _msstart, _mscols, _dref)
end

function getglobal64(prob::XpressProblem, ngents, nsets, _sgtype, _mgcols, _dlim, _sstype, _msstart, _mscols, _dref)
    @checked Lib.XPRSgetglobal64(prob, ngents, nsets, _sgtype, _mgcols, _dlim, _sstype, _msstart, _mscols, _dref)
end

"""

    writeprob(prob::XpressProblem, _sfilename, _sflags)

*Purpose*

Writes the current
problem to an MPS or LP file.

*Synopsis*

int XPRS_CC XPRSwriteprob(XPRSprob prob, const char *filename, const char *flags);

*Arguments*

`prob`: The current problem.
`filename`: A string of up to
`MAXPROBNAMELENGTH characters to contain the file name to which the problem is to be written. If omitted, the default`: problem_name is used with a
`.mps extension, unless the`: l flag is used in which case the extension is
`.lp.`: flags
`Flags, which can be one or more of the following:`: h
`single precision of numerical values;`: o
`one element per line;`: n
`scaled;`: s
`scrambled vector names;`: l
`output in LP format;`: x
`output MPS file in hexadecimal format.`: p

*Example*

WRITEPROB -x C:myprob

*Related*

XPRSreadprob (
READPROB).
"""
function writeprob(prob::XpressProblem, _sfilename::String, _sflags="")
    @checked Lib.XPRSwriteprob(prob, _sfilename, _sflags)
end

"""

    getnames(prob::XpressProblem, _itype, _sbuff, first, last)

*Purpose*

Returns the names for the
rows,
columns or
set in a given range. The names will be returned in a character buffer, each name being separated by a null character.

*Synopsis*

int XPRS_CC XPRSgetnames(XPRSprob prob, int type, char names[], int first, int last);

*Arguments*

`prob`: The current problem.
`type`: 1
`if row names are required;`: 2
`if column names are required.`: 3
`if set names are required.`: names
`Buffer long enough to hold the names. Since each name is`: 8*NAMELENGTH characters long (plus a null terminator), the array,
`names, would be required to be at least as long as (`: first-last+1)*(
`8*NAMELENGTH+1) characters. The names of the row/column/set`: first+i will be written into the
`names buffer starting at position`: i*8*NAMELENGTH+i.
`first`: First row, column or set in the range.
`last`: Last row, column or set in the range.

*Example*

The following example retrieves the row and column names of the current problem:

*Related*

XPRSaddnames,
XPRSgetnamelist.
"""
function getnames(prob::XpressProblem, _itype, _sbuff, first::Integer, last::Integer)
    @checked Lib.XPRSgetnames(prob, _itype, _sbuff, first, last)
end

"""

    getrowtype(prob::XpressProblem, _srowtype, first, last)

*Purpose*

Returns the
row types for the rows in a given range.

*Synopsis*

int XPRS_CC XPRSgetrowtype(XPRSprob prob, char qrtype[], int first, int last);

*Arguments*

`prob`: The current problem.
`qrtype`: Character array of length
`last-first+1 characters where the row types will be returned:`: N
`indicates a free constraint;`: L
`indicates a â¤ constraint;`: E
`indicates an = constraint;`: G
`indicates a â¥ constraint;`: R
`indicates a range constraint.`: first
`First row in the range.`: last

*Example*

The following example retrieves row types into an array
qrtype :

*Related*

XPRSchgrowtype,
XPRSgetrowrange,
XPRSgetrows.
"""
function getrowtype(prob::XpressProblem, first::Integer, last::Integer)
    n_elems = last - first + 1
    if n_elems <= 0
        n_elems = n_constraints(prob)
        first = 0
        last = n_elems - 1
    else
        first = first - 1
        last = last - 1
    end
    _srowtype = Vector{Cchar}(undef, n_elems)
    @checked Lib.XPRSgetrowtype(prob, _dbdl, first, last)
    return _srowtype
end

"""

    loadsecurevecs(prob::XpressProblem, nrows, ncols, mrow, mcol)

*Purpose*

Allows the user to mark rows and columns in order to prevent the
presolve removing these rows and columns from the matrix.

*Synopsis*

int XPRS_CC XPRSloadsecurevecs(XPRSprob prob, int nr, int nc, const int mrow[], const int mcol[]);

*Arguments*

`prob`: The current problem.
`nr`: Number of rows to be marked.
`nc`: Number of columns to be marked.
`mrow`: Integer array of length
`nr containing the rows to be marked. May be`: NULL if not required.
`mcol`: Integer array of length
`nc containing the columns to be marked. May be`: NULL if not required.

*Example*

This sets the first six rows and the first four columns to not be removed during presolve.

*Related*

Working with Presolve.
"""
function loadsecurevecs(prob::XpressProblem, nrows, ncols, mrow, mcol)
    @checked Lib.XPRSloadsecurevecs(prob, nrows, ncols, mrow, mcol)
end

"""

    getcoltype(prob::XpressProblem, _coltype, first, last)

*Purpose*

Returns the column types for the
columns in a given range.

*Synopsis*

int XPRS_CC XPRSgetcoltype(XPRSprob prob, char coltype[], int first, int last);

*Arguments*

`prob`: The current problem.
`coltype`: Character array of length
`last-first+1 where the column types will be returned:`: C
`indicates a continuous variable;`: I
`indicates an integer variable;`: B
`indicates a binary variable;`: S
`indicates a semi-continuous variable;`: R
`indicates a semi-continuous integer variable;`: P
`indicates a partial integer variable.`: first
`First column in the range.`: last

*Example*

This example finds the types for all columns in the matrix and prints them to the console:

*Related*

XPRSchgcoltype,
XPRSgetrowtype.
"""
function getcoltype(prob::XpressProblem, first::Integer, last::Integer)
    n_elems = last - first + 1
    if n_elems <= 0
        n_elems = n_variables(prob)
        first = 0
        last = n_elems - 1
    else
        first = first - 1
        last = last - 1
    end
    _coltype = Vector{Cchar}(undef, n_elems)
    @checked Lib.XPRSgetcoltype(prob, _coltype, first, last)
    return _coltype
end

"""

    getbasis(prob::XpressProblem, _mrowstatus, _mcolstatus)

*Purpose*

Returns the current basis into the user's data arrays.

*Synopsis*

int XPRS_CC XPRSgetbasis(XPRSprob prob, int rstatus[], int cstatus[]);

*Arguments*

`prob`: The current problem.
`rstatus`: Integer array of length
`ROWS to the basis status of the slack, surplus or artificial variable associated with each row. The status will be one of:`: 0
`slack, surplus or artificial is non-basic at lower bound;`: 1
`slack, surplus or artificial is basic;`: 2
`slack or surplus is non-basic at upper bound.`: 3
`slack or surplus is super-basic.`: May be
`NULL if not required.`: cstatus
`Integer array of length`: COLS to hold the basis status of the columns in the constraint matrix. The status will be one of:
`0`: variable is non-basic at lower bound, or superbasic at zero if the variable has no lower bound;
`1`: variable is basic;
`2`: variable is non-basic at upper bound;
`3`: variable is super-basic.
`May be`: NULL if not required.

*Example*

The following example minimizes a problem before saving the basis for later:

*Related*

XPRSgetpresolvebasis,
XPRSloadbasis,
XPRSloadpresolvebasis.
"""
function getbasis(prob::XpressProblem, _mrowstatus, _mcolstatus)
    @checked Lib.XPRSgetbasis(prob, _mrowstatus, _mcolstatus)
end

"""

    loadbasis(prob::XpressProblem, _mrowstatus, _mcolstatus)

*Purpose*

Loads a
basis from the user's areas.

*Synopsis*

int XPRS_CC XPRSloadbasis(XPRSprob prob, const int rstatus[], const int cstatus[]);

*Arguments*

`prob`: The current problem.
`rstatus`: Integer array of length
`ROWS containing the basis status of the slack, surplus or artificial variable associated with each row. The status must be one of:`: 0
`slack, surplus or artificial is non-basic at lower bound;`: 1
`slack, surplus or artificial is basic;`: 2
`slack or surplus is non-basic at upper bound.`: 3
`slack or surplus is super-basic.`: cstatus
`Integer array of length`: COLS containing the basis status of each of the columns in the constraint matrix. The status must be one of:
`0`: variable is non-basic at lower bound or superbasic at zero if the variable has no lower bound;
`1`: variable is basic;
`2`: variable is at upper bound;
`3`: variable is super-basic.

*Example*

This example loads a problem and then reloads a (previously optimized) basis from a similar problem to speed up the optimization:

*Related*

XPRSgetbasis,
XPRSgetpresolvebasis,
XPRSloadpresolvebasis.
"""
function loadbasis(prob::XpressProblem, _mrowstatus, _mcolstatus)
    @checked Lib.XPRSloadbasis(prob, _mrowstatus, _mcolstatus)
end

"""

    getindex(prob::XpressProblem, _itype, _sname, _iseq)

*Purpose*

Returns the index for a specified
row or
column name.

*Synopsis*

int XPRS_CC XPRSgetindex(XPRSprob prob, int type, const char *name, int *seq);

*Arguments*

`prob`: The current problem.
`type`: 1
`if a row index is required;`: 2
`if a column index is required.`: name
`Null terminated string.`: seq
`Pointer of the integer where the row or column index number will be returned. A value of`: -1 will be returned if the row or column does not exist.

*Example*

The following example loads
problem and checks to see if "
n 0203" is the name of a row or column:

*Related*

XPRSaddnames.
"""
function getindex(prob::XpressProblem, _itype, _sname, _iseq)
    @checked Lib.XPRSgetindex(prob, _itype, _sname, _iseq)
end

"""

    addrows(prob::XpressProblem, _srowtype::Vector{Cchar}, _drhs::Vector{Float64}, _drng, _mstart::Vector{Int}, _mclind::Vector{Int}, _dmatval::Vector{Float64})

*Purpose*

Allows
rows to be added to the matrix after passing it to the Optimizer using the input routines.

*Synopsis*

int XPRS_CC XPRSaddrows(XPRSprob prob, int newrow, int newnz, const char qrtype[], const double rhs[], const double range[], const int mstart[], const int mclind[], const double dmatval[]);

*Arguments*

`prob`: The current problem.
`newrow`: Number of new rows.
`newnz`: Number of new nonzeros in the added rows.
`qrtype`: Character array of length newrow containing the row types:
`L`: indicates a â¤ row;
`G`: indicates â¥ row;
`E`: indicates an = row.
`R`: indicates a range constraint;
`N`: indicates a nonbinding constraint.
`rhs`: Double array of length
`newrow containing the right hand side elements.`: range
`Double array of length`: newrow containing the row range elements. This may be
`NULL if there are no ranged constraints. The values in the`: range array will only be read for
`R type rows. The entries for other type rows will be ignored.`: mstart
`Integer array of length`: newrow containing the offsets in the
`mclind and`: dmatval arrays of the start of the elements for each row.
`mclind`: Integer array of length
`newnz containing the (contiguous) column indices for the elements in each row.`: dmatval
`Double array of length`: newnz containing the (contiguous) element values.

*Example*

Suppose the current problem is:
maximize:
2x + y + 3z
subject to:
x + 4y + 2z
â¤
24
y + z
â¤
5
3x + y
â¤
20
x + y + 3z
â¤
9
Then the following adds the row 8x + 9y + 10z â¤ 25 to the problem and names it
NewRow:

*Related*

XPRSaddcols,
XPRSaddcuts,
XPRSaddnames,
XPRSdelrows.
"""
function addrows(prob::XpressProblem, _srowtype::Vector{Cchar}, _drhs::Vector{Float64}, _drng, _mstart::Vector{Int}, _mclind::Vector{Int}, _dmatval::Vector{Float64})
    nrows = length(_drhs)
    # @assert nrows == length(_drng) # can be a C_NULL
    @assert nrows == length(_srowtype)
    ncoeffs = length(_mclind)
    @assert ncoeffs == length(_mstart)
    @assert ncoeffs == length(_dmatval)
    @checked Lib.XPRSaddrows(prob, nrows, ncoeffs, _srowtype, _drhs, _drng, _mstart.-1, _mclind.-1, _dmatval)
end

function addrows64(prob::XpressProblem, nrows, ncoeffs, _srowtype, _drhs, _drng, _mstart, _mclind, _dmatval)
    @checked Lib.XPRSaddrows64(prob, nrows, ncoeffs, _srowtype, _drhs, _drng, _mstart, _mclind, _dmatval)
end

"""

    delrows(prob::XpressProblem, nrows, _mindex)

*Purpose*

Delete rows from a
matrix.

*Synopsis*

int XPRS_CC XPRSdelrows(XPRSprob prob, int nrows, const int mindex[]);

*Arguments*

`prob`: The current problem.
`nrows`: Number of rows to delete.
`mindex`: An integer array of length

*Example*

In this example, rows
0 and
10 are deleted from the matrix:

*Related*

XPRSaddrows,
XPRSdelcols,
XPRSgetbasis,
XPRSgetpivots,
XPRSpivot.
"""
function delrows(prob::XpressProblem, nrows::Int, _mindex::Vector{Int})
    @checked Lib.XPRSdelrows(prob, nrows, _mindex)
end

"""

    addcols(prob::XpressProblem, ncols, ncoeffs, _dobj, _mstart, _mrwind, _dmatval, _dbdl, _dbdu)

*Purpose*

Allows columns to be added to the
matrix after passing it to the Optimizer using the input routines.

*Synopsis*

int XPRS_CC XPRSaddcols(XPRSprob prob, int newcol, int newnz, const double objx[], const int mstart[], const int mrwind[], const double dmatval[], const double bdl[], const double bdu[]);

*Arguments*

`prob`: The current problem.
`newcol`: Number of new columns.
`newnz`: Number of new nonzeros in the added columns.
`objx`: Double array of length
`newcol containing the objective function coefficients of the new columns.`: mstart
`Integer array of length`: newcol containing the offsets in the
`mrwind and`: dmatval arrays of the start of the elements for each column.
`mrwind`: Integer array of length
`newnz containing the row indices for the elements in each column.`: dmatval
`Double array of length`: newnz containing the element values.
`bdl`: Double array of length
`newcol containing the lower bounds on the added columns.`: bdu
`Double array of length`: newcol containing the upper bounds on the added columns.

*Example*

In this example, we consider the two problems:
(a)
maximize:
2x + y
(b)
maximize:
2x + y + 3z
subject to:
x + 4y
â¤
24
subject to:
x + 4y + 2z
â¤
24
y
â¤
5
y + z
â¤
5
3x + y
â¤
20
3x + y
â¤
20
x + y
â¤
9
x + y + 3z
â¤
9
z
â¤
12

*Related*

XPRSaddnames,
XPRSaddrows,
XPRSdelcols,
XPRSchgcoltype.
"""
function addcols(prob::XpressProblem, _dobj::Vector{Float64}, _mstart::Vector{Int}, _mrwind::Vector{Int}, _dmatval::Vector{Float64}, _dbdl::Vector{Float64}, _dbdu::Vector{Float64})
    @assert length(_dbdl) == length(_dbdu)
    fixinfinity!(_dbdl)
    fixinfinity!(_dbdu)
    ncols = length(_dbdl)
    ncoeffs = length(_dmatval)
    _mstart = _mstart - 1
    _mrwind = _mrwind - 1
    @checked Lib.XPRSaddcols(prob, ncols, ncoeffs, _dobj, _mstart, _mrwind, _dmatval, _dbdl, _dbdu)
end

function addcols64(prob::XpressProblem, _dobj, _mstart, _mrwind, _dmatval, _dbdl::Vector{Float64}, _dbdu::Vector{Float64})
    @assert length(_dbdl) == length(_dbdu)
    fixinfinity!(_dbdl)
    fixinfinity!(_dbdu)
    ncols = length(_dbdl)
    ncoeffs = length(_dmatval)
    _mstart = _mstart - 1
    _mrwind = _mrwind - 1
    @checked Lib.XPRSaddcols64(prob, ncols, ncoeffs, _dobj, _mstart, _mrwind, _dmatval, _dbdl, _dbdu)
end

"""

    delcols(prob::XpressProblem, ncols, _mindex)

*Purpose*

Delete columns from a
matrix.

*Synopsis*

int XPRS_CC XPRSdelcols(XPRSprob prob, int ncols, const int mindex[]);

*Arguments*

`prob`: The current problem.
`ncols`: Number of columns to delete.
`mindex`: Integer array of length

*Example*

In this example, column
3 is deleted from the matrix:

*Related*

XPRSaddcols,
XPRSdelrows.
"""
function delcols(prob::XpressProblem, _mindex::Vector{Int})
    ncols = length(_mindex)
    _mindex = _mindex - 1
    @checked Lib.XPRSdelcols(prob, ncols, _mindex)
end

"""

    chgcoltype(prob::XpressProblem, ncols, _mindex, _coltype)

*Purpose*

Used to change the type of a column in the matrix.

*Synopsis*

int XPRS_CC XPRSchgcoltype(XPRSprob prob, int nels, const int mindex[], const char qctype[]);

*Arguments*

`prob`: The current problem.
`nels`: Number of columns to change.
`mindex`: Integer array of length
`nels containing the indices of the columns.`: qctype
`Character array of length`: nels giving the new column types:
`C`: indicates a continuous column;
`B`: indicates a binary column;
`I`: indicates an integer column.
`S`: indicates a semiâcontinuous column. The semiâcontinuous lower bound will be set to
`1.0.`: R
`indicates a semiâinteger column. The semiâinteger lower bound will be set to`: 1.0.
`P`: indicates a partial integer column. The partial integer bound will be set to

*Example*

The following changes columns
3 and
5 of the matrix to be integer and binary respectively:

*Related*

XPRSaddcols,
XPRSchgrowtype,
XPRSdelcols,
XPRSgetcoltype.
"""
function chgcoltype(prob::XpressProblem, _mindex::Vector{Int}, _coltype::Vector{Cchar})
    ncols = length(_mindex)
    _mindex = _mindex - 1
    _coltype
    @checked Lib.XPRSchgcoltype(prob, ncols, _mindex, _coltype)
end

"""

    chgrowtype(prob::XpressProblem, nrows, _mindex, _srowtype)

*Purpose*

Used to change the type of a row in the
matrix.

*Synopsis*

int XPRS_CC XPRSchgrowtype(XPRSprob prob, int nels, const int mindex[], const char qrtype[]);

*Arguments*

`prob`: The current problem.
`nels`: Number of rows to change.
`mindex`: Integer array of length
`nels containing the indices of the rows.`: qrtype
`Character array of length`: nels giving the new row types:
`L`: indicates a â¤ row;
`E`: indicates an = row;
`G`: indicates a â¥ row;
`R`: indicates a range row;
`N`: indicates a free row.

*Example*

Here row
4 is changed to an equality row:

*Related*

XPRSaddrows,
XPRSchgcoltype,
XPRSchgrhs,
XPRSchgrhsrange,
XPRSdelrows,
XPRSgetrowrange,
XPRSgetrowtype.
"""
function chgrowtype(prob::XpressProblem, _mindex::Vector{Int}, _srowtype::Vector{Cchar})
    nrows = length(_mindex)
    _mindex = _mindex .- 1
    @checked Lib.XPRSchgrowtype(prob, nrows, _mindex, _srowtype)
end

"""

    chgbounds(prob::XpressProblem, nbnds, _mindex, _sboundtype, _dbnd)

*Purpose*

Used to change the
bounds on columns in the
matrix.

*Synopsis*

int XPRS_CC XPRSchgbounds(XPRSprob prob, int nbnds, const int mindex[], const char qbtype[], const double bnd[]);

*Arguments*

`prob`: The current problem.
`nbnds`: Number of bounds to change.
`mindex`: Integer array of size
`nbnds containing the indices of the columns on which the bounds will change.`: qbtype
`Character array of length`: nbnds indicating the type of bound to change:
`U`: indicates change the upper bound;
`L`: indicates change the lower bound;
`B`: indicates change both bounds, i.e. fix the column.
`bnd`: Double array of length

*Example*

The following changes column
0 of the current problem to have an upper bound of
0.5:

*Related*

XPRSgetlb,
XPRSgetub,
XPRSstorebounds.
"""
function chgbounds(prob::XpressProblem, _mindex::Vector{Int}, _sboundtype::Vector{Cchar}, _dbnd::Vector{Float64})
    nbnds = length(_mindex)
    _mindex = _mindex .- 1
    @checked Lib.XPRSchgbounds(prob, nbnds, _mindex, _sboundtype, _dbnd)
end

"""

    chgobj(prob::XpressProblem, ncols, _mindex, _dobj)

*Purpose*

Used to change the
objective function coefficients.

*Synopsis*

int XPRS_CC XPRSchgobj(XPRSprob prob, int nels, const int mindex[], const double obj[]);

*Arguments*

`prob`: The current problem.
`nels`: Number of objective function coefficient elements to change.
`mindex`: Integer array of length
`nels containing the indices of the columns on which the range elements will change. An index of`: -1 indicates that the fixed part of the objective function on the right hand side should change.
`obj`: Double array of length

*Example*

Changing three coefficients of the objective function with
XPRSchgobj :

*Related*

XPRSchgcoef,
XPRSchgmcoef,
XPRSchgmqobj,
XPRSchgqobj,
XPRSgetobj.
"""
function chgobj(prob::XpressProblem, ncols::Int, _mindex::Vector{Int}, _dobj::Vector{Float64})
    @assert length(_dobj) == ncols
    _mindex = _mindex .- 1
    @checked Lib.XPRSchgobj(prob, ncols, _mindex, _dobj)
end

"""

    chgcoef(prob::XpressProblem, _irow, _icol, _dval)

*Purpose*

Used to change a single coefficient in the
matrix. If the coefficient does not already exist, a new coefficient will be added to the matrix. If many coefficients are being added to a row of the matrix, it may be more efficient to delete the old row of the matrix and add a new row.

*Synopsis*

int XPRS_CC XPRSchgcoef(XPRSprob prob, int irow, int icol, double dval);

*Arguments*

`prob`: The current problem.
`irow`: Row index for the coefficient.
`icol`: Column index for the coefficient.
`dval`: New value for the coefficient. If

*Example*

In the following, the element in row
2, column
1 of the matrix is changed to
0.33:

*Related*

XPRSaddcols,
XPRSaddrows,
XPRSchgmcoef,
XPRSchgmqobj,
XPRSchgobj,
XPRSchgqobj,
XPRSchgrhs,
XPRSgetcols,
XPRSgetrows.
"""
function chgcoef(prob::XpressProblem, _irow, _icol, _dval)
    @checked Lib.XPRSchgcoef(prob, _irow, _icol, _dval)
end

"""

    chgmcoef(prob::XpressProblem, ncoeffs, _mrow, _mcol, _dval)

*Purpose*

Used to change multiple coefficients in the
matrix. If any coefficient does not already exist, it will be added to the matrix. If many coefficients are being added to a row of the matrix, it may be more efficient to delete the old row of the matrix and add a new one.

*Synopsis*

int XPRS_CC XPRSchgmcoef(XPRSprob prob, int nels, const int mrow[], const int mcol[], const double dval[]);

*Arguments*

`prob`: The current problem.
`nels`: Number of new coefficients.
`mrow`: Integer array of length
`nels containing the row indices of the coefficients to be changed.`: mcol
`Integer array of length`: nels containing the column indices of the coefficients to be changed.
`dval`: Double array of length
`nels containing the new coefficient values. If an element of`: dval is zero, the coefficient will be deleted.

*Example*

mrow[0] = 0; mrow[1] = 3;
mcol[0] = 1; mcol[1] = 5;
dval[0] = 2.0; dval[1] = 0.0;
XPRSchgmcoef(prob,2,mrow,mcol,dval);

*Related*

XPRSchgcoef,
XPRSchgmqobj,
XPRSchgobj,
XPRSchgqobj,
XPRSchgrhs,
XPRSgetcols,
XPRSgetrhs.
"""
function chgmcoef(prob::XpressProblem, ncoeffs, _mrow, _mcol, _dval)
    @checked Lib.XPRSchgmcoef(prob, ncoeffs, _mrow, _mcol, _dval)
end

function chgmcoef64(prob::XpressProblem, ncoeffs, _mrow, _mcol, _dval)
    @checked Lib.XPRSchgmcoef64(prob, ncoeffs, _mrow, _mcol, _dval)
end

"""

    chgmqobj(prob::XpressProblem, ncols, _mcol1, _mcol2, _dval)

*Purpose*

Used to change multiple
quadratic coefficients in the
objective function. If any of the coefficients does not exist already, new coefficients will be added to the objective function.

*Synopsis*

int XPRS_CC XPRSchgmqobj(XPRSprob prob, int nels, const int mqcol1[], const int mqcol2[], const double dval[]);

*Arguments*

`prob`: The current problem.
`nels`: The number of coefficients to change.
`mqcol1`: Integer array of size
`ncol containing the column index of the first variable in each quadratic term.`: mqcol2
`Integer array of size`: ncol containing the column index of the second variable in each quadratic term.
`dval`: New values for the coefficients. If an entry in
`dval is`: 0, the corresponding entry will be deleted. These are the coefficients of the quadratic Hessian matrix.

*Example*

The following code results in an objective function with terms:
[6x12 + 3x1x2 + 3x2x1]/2

*Related*

XPRSchgcoef,
XPRSchgmcoef,
XPRSchgobj,
XPRSchgqobj,
XPRSgetqobj.
"""
function chgmqobj(prob::XpressProblem, ncols, _mcol1, _mcol2, _dval)
    @checked Lib.XPRSchgmqobj(prob, ncols, _mcol1, _mcol2, _dval)
end

function chgmqobj64(prob::XpressProblem, ncols, _mcol1, _mcol2, _dval)
    @checked Lib.XPRSchgmqobj64(prob, ncols, _mcol1, _mcol2, _dval)
end

"""

    chgqobj(prob::XpressProblem, _icol, _jcol, _dval)

*Purpose*

Used to change a single
quadratic coefficient in the
objective function corresponding to the variable pair
(icol,jcol) of the
Hessian matrix.

*Synopsis*

int XPRS_CC XPRSchgqobj(XPRSprob prob, int icol, int jcol, double dval);

*Arguments*

`prob`: The current problem.
`icol`: Column index for the first variable in the quadratic term.
`jcol`: Column index for the second variable in the quadratic term.
`dval`: New value for the coefficient in the quadratic Hessian matrix. If an entry in
`dval is`: 0, the corresponding entry will be deleted.

*Example*

The following code adds the terms
[15x12 + 7x1x2]/2 to the objective function:

*Related*

XPRSchgcoef,
XPRSchgmcoef,
XPRSchgmqobj,
XPRSchgobj,
XPRSgetqobj.
"""
function chgqobj(prob::XpressProblem, _icol, _jcol, _dval)
    @checked Lib.XPRSchgqobj(prob, _icol, _jcol, _dval)
end

"""

    chgrhs(prob::XpressProblem, nrows, _mindex, _drhs)

*Purpose*

Used to change
rightâhand side values of the
problem.

*Synopsis*

int XPRS_CC XPRSchgrhs(XPRSprob prob, int nels, const int mindex[], const double rhs[]);

*Arguments*

`prob`: The current problem.
`nels`: Number of right hand side values to change.
`mindex`: Integer array of length
`nels containing the indices of the rows on which the right hand side values will change.`: rhs
`Double array of length`: nels giving the right hand side values.

*Example*

Here we change the three right hand sides in rows
2,
6, and
8 to new values:

*Related*

XPRSchgcoef,
XPRSchgmcoef,
XPRSchgrhsrange,
XPRSgetrhs,
XPRSgetrhsrange.
"""
function chgrhs(prob::XpressProblem, _mindex::Vector{Int}, _drhs::Vector{Float64})
    nrows = length(_mindex)
    _mindex = _mindex .- 1
    @checked Lib.XPRSchgrhs(prob, nrows, _mindex, _drhs)
end

"""

    chgrhsrange(prob::XpressProblem, nrows, _mindex, _drng)

*Purpose*

Used to change the
range for a row of the problem
matrix.

*Synopsis*

int XPRS_CC XPRSchgrhsrange(XPRSprob prob, int nels, const int mindex[], const double rng[]);

*Arguments*

`prob`: The current problem.
`nels`: Number of range elements to change.
`mindex`: Integer array of length
`nels containing the indices of the rows on which the range elements will change.`: rng
`Double array of length`: nels giving the range values.

*Example*

Here, the constraint x + y â¤ 10 (with row index 5) in the problem is changed to 8 â¤ x + y â¤ 10:

*Related*

XPRSchgcoef,
XPRSchgmcoef,
XPRSchgrhs,
XPRSgetrhsrange.
"""
function chgrhsrange(prob::XpressProblem, nrows::Int, _mindex::Vector{Int}, _drng::Vector{Float64})
    @checked Lib.XPRSchgrhsrange(prob, nrows, _mindex, _drng)
end

"""

    chgobjsense(prob::XpressProblem, objsense)

*Purpose*

Changes the problem's objective function sense to minimize or maximize.

*Synopsis*

int XPRS_CC XPRSchgobjsense(XPRSprob prob, int objsense);

*Arguments*

`prob`: The current problem.
`objsense`: XPRS_OBJ_MINIMIZE to change into a minimization, or

*Example*



*Related*

XPRSlpoptimize,
XPRSmipoptimize.
"""
function chgobjsense(prob::XpressProblem, objsense::Union{Symbol, Int})
    v = objsense == :maximize || objsense == :Max || objsense == Lib.XPRS_OBJ_MAXIMIZE ? Lib.XPRS_OBJ_MAXIMIZE :
        objsense == :minimize || objsense == :Min || objsense == Lib.XPRS_OBJ_MINIMIZE ? Lib.XPRS_OBJ_MINIMIZE :
        throw(ArgumentError("Invalid objective sense: $objsense. It can only be `:maximize`, `:minimize`, `:Max`, `:Min`, `$(Lib.XPRS_OBJ_MAXIMIZE)`, or `$(Lib.XPRS_OBJ_MINIMIZE)`."))
    @checked Lib.XPRSchgobjsense(prob, v)
end

"""

    chgglblimit(prob::XpressProblem, ncols, _mindex, _dlimit)

*Purpose*

Used to change semi-continuous or semi-integer lower bounds, or upper limits on partial integers.

*Synopsis*

int XPRS_CC XPRSchgglblimit(XPRSprob prob, int ncols, const int mindex[], const double dlimit[]);

*Arguments*

`prob`: The current problem.
`ncols`: Number of column limits to change.
`mindex`: Integer array of size
`ncols containing the indices of the semi-continuous, semi-integer or partial integer columns that should have their limits changed.`: dlimit
`Double array of length`: ncols giving the new limit values.

*Example*



*Related*

XPRSchgcoltype,
XPRSgetglobal.
"""
function chgglblimit(prob::XpressProblem, _mindex::Vector{Int}, _dlimit::Vector{Float64})
    ncols = length(_mindex)
    _mindex = _mindex - 1
    @checked Lib.XPRSchgglblimit(prob, _mindex, _dlimit)
end

"""

    save(prob::XpressProblem)

*Purpose*

Saves the current data structures, i.e. matrices, control settings and problem attribute settings to file and terminates the run so that optimization can be resumed later.

*Synopsis*

int XPRS_CC XPRSsave(XPRSprob prob);

*Arguments*

`prob`: The current problem.
`filename`: The name of the file to save to.

*Example*

SAVE

*Related*

XPRSrestore (
RESTORE).
"""
function save(prob::XpressProblem)
    @checked Lib.XPRSsave(prob)
end

"""

    restore(prob::XpressProblem, _sprobname, _force)

*Purpose*

Restores the Optimizer's data structures from a file created by
XPRSsave
(
SAVE). Optimization may then recommence from the point at which the file was created.

*Synopsis*

int XPRS_CC XPRSrestore(XPRSprob prob, const char *probname, const char *flags);

*Arguments*

`prob`: The current problem.
`probname`: A string of up to
`MAXPROBNAMELENGTH characters containing the problem name.`: flags
`f`: Force the restoring of a save file even if it is from a different version.

*Example*

RESTORE

*Related*

XPRSalter (
ALTER),
XPRSsave (
SAVE).
"""
function restore(prob::XpressProblem, _sprobname, _force)
    @checked Lib.XPRSrestore(prob, _sprobname, _force)
end

"""

    pivot(prob::XpressProblem, _in, _out)

*Purpose*

Performs a simplex pivot by bringing variable
in into the basis and removing
out.

*Synopsis*

int XPRS_CC XPRSpivot(XPRSprob prob, int in, int out);

*Arguments*

`prob`: The current problem.
`in`: Index of row or column to enter basis.
`out`: Index of row or column to leave basis.

*Example*

The following brings the 7th variable into the basis and removes the 5th:

*Related*

XPRSgetpivotorder,
XPRSgetpivots.
"""
function pivot(prob::XpressProblem, _in, _out)
    @checked Lib.XPRSpivot(prob, _in, _out)
end

"""

    getpivots(prob::XpressProblem, _in, _mout, _dout, _dobjo, npiv, maxpiv)

*Purpose*

Returns a list of potential
leaving variables if a specified variable enters the basis.

*Synopsis*

int XPRS_CC XPRSgetpivots(XPRSprob prob, int in, int outlist[], double x[], double *dobj, int *npiv, int maxpiv);

*Arguments*

`prob`: The current problem.
`in`: Index of the specified row or column to enter basis.
`outlist`: Integer array of length at least
`maxpiv to hold list of potential leaving variables. May be`: NULL if not required.
`x`: Double array of length
`ROWS`: +
`SPAREROWS`: +
`COLS to hold the values of all the variables that would result if`: in entered the basis. May be
`NULL if not required.`: dobj
`Pointer to a double where the objective function value that would result if`: in entered the basis will be returned.
`npiv`: Pointer to an integer where the actual number of potential leaving variables will be returned.
`maxpiv`: Maximum number of potential leaving variables to return.

*Example*

The following retrieves a list of up to 5 potential leaving variables if variable 6 enters the basis:

*Related*

XPRSgetpivotorder,
XPRSpivot.
"""
function getpivots(prob::XpressProblem, _in, _mout, _dout, _dobjo, npiv, maxpiv)
    @checked Lib.XPRSgetpivots(prob, _in, _mout, _dout, _dobjo, npiv, maxpiv)
end

"""

    addcuts(prob::XpressProblem, ncuts, mtype, qrtype, drhs, mstart, mcols, dmatval)

*Purpose*

Adds
cuts directly to the matrix at the current node. Any cuts added to the matrix at the current node and not deleted at the current node will be automatically added to the
cut pool. The cuts added to the cut pool will be automatically restored at descendant nodes.

*Synopsis*

int XPRS_CC XPRSaddcuts(XPRSprob prob, int ncuts, const int mtype[], const char qrtype[], const double drhs[], const int mstart[], const int mcols[], const double dmatval[]);

*Arguments*

`prob`: The current problem.
`ncuts`: Number of cuts to add.
`mtype`: Integer array of length
`ncuts containing the user assigned cut types. The cut types can be any integer chosen by the user, and are used to identify the cuts in other cut manager routines using user supplied parameters. The cut type can be interpreted as an integer or a bitmap - see`: XPRSdelcuts.
`qrtype`: Character array of length
`ncuts containing the row types:`: L
`indicates a â¤ row;`: G
`indicates a â¥ row;`: E
`indicates an = row.`: drhs
`Double array of length`: ncuts containing the right hand side elements for the cuts.
`mstart`: Integer array containing offset into the
`mcols and`: dmatval arrays indicating the start of each cut. This array is of length
`ncuts+1 with the last element,`: mstart[ncuts], being where cut
`ncuts+1 would start.`: mcols
`Integer array of length`: mstart[ncuts] containing the column indices in the cuts.
`dmatval`: Double array of length

*Example*



*Related*

XPRSaddrows,
XPRSdelcpcuts,
XPRSdelcuts,
XPRSgetcpcutlist,
XPRSgetcutlist,
XPRSloadcuts,
XPRSstorecuts, Section
Working with the Cut Manager.
"""
function addcuts(prob::XpressProblem, ncuts, mtype, qrtype, drhs, mstart, mcols, dmatval)
    @checked Lib.XPRSaddcuts(prob, ncuts, mtype, qrtype, drhs, mstart, mcols, dmatval)
end

function addcuts64(prob::XpressProblem, ncuts, mtype, qrtype, drhs, mstart, mcols, dmatval)
    @checked Lib.XPRSaddcuts64(prob, ncuts, mtype, qrtype, drhs, mstart, mcols, dmatval)
end

"""

    delcuts(prob::XpressProblem, ibasis, itype, interp, delta, ncuts, mcutind)

*Purpose*

Deletes
cuts from the
matrix at the current
node. Cuts from the parent
node which have been automatically restored may be deleted as well as cuts added to the current node using
XPRSaddcuts or
XPRSloadcuts. The cuts to be deleted can be specified in a number of ways. If a cut is ruled out by any one of the criteria it will not be deleted.

*Synopsis*

int XPRS_CC XPRSdelcuts(XPRSprob prob, int ibasis, int itype, int interp, double delta, int num, const XPRScut mcutind[]);

*Arguments*

`prob`: The current problem.
`ibasis`: Ensures the basis will be valid if set to
`1. If set to`: 0, cuts with non-basic slacks may be deleted.
`itype`: User defined type of the cut to be deleted.
`interp`: Way in which the cut
`itype is interpreted:`: -1
`match all cut types;`: 1
`treat cut types as numbers;`: 2
`treat cut types as bit maps - delete if any bit matches any bit set in`: itype;
`3`: treat cut types as bit maps - delete if all bits match those set in
`itype.`: delta
`Only delete cuts with an absolute slack value greater than`: delta. To delete all the cuts, this argument should be set to
`XPRS_MINUSINFINITY.`: num
`Number of cuts to drop if a list of cuts is provided. A value of`: -1 indicates all cuts.
`mcutind`: Array containing pointers to the cuts which are to be deleted. This array may be
`NULL if`: num is set to
`-1 otherwise it has length`: num.

*Example*



*Related*

XPRSaddcuts,
XPRSdelcpcuts,
XPRSgetcutlist,
XPRSloadcuts, Section
Working with the Cut Manager.
"""
function delcuts(prob::XpressProblem, ibasis, itype, interp, delta, ncuts, mcutind)
    @checked Lib.XPRSdelcuts(prob, ibasis, itype, interp, delta, ncuts, mcutind)
end

"""

    delcpcuts(prob::XpressProblem, itype, interp, ncuts, mcutind)

*Purpose*

During the branch and bound search, cuts are stored in the
cut pool to be applied at descendant nodes. These cuts may be removed from a given node using
XPRSdelcuts, but if this is to be applied in a large number of cases, it may be preferable to remove the cut completely from the cut pool. This is achieved using
XPRSdelcpcuts.

*Synopsis*

int XPRS_CC XPRSdelcpcuts(XPRSprob prob, int itype, int interp, int ncuts, const XPRScut mcutind[]);

*Arguments*

`prob`: The current problem.
`itype`: User defined cut type to match against.
`interp`: Way in which the cut
`itype is interpreted:`: -1
`match all cut types;`: 1
`treat cut types as numbers;`: 2
`treat cut types as bit maps - delete if any bit matches any bit set in`: itype;
`3`: treat cut types as bit maps - delete if all bits match those set in
`itype.`: ncuts
`The number of cuts to delete. A value of`: -1 indicates delete all cuts.
`mcutind`: Array containing pointers to the cuts which are to be deleted. This array may be
`NULL if`: ncuts is
`-1, otherwise it has length`: ncuts.

*Example*



*Related*

XPRSaddcuts,
XPRSdelcuts,
XPRSloadcuts, Section
Working with the Cut Manager.
"""
function delcpcuts(prob::XpressProblem, itype, interp, ncuts, mcutind)
    @checked Lib.XPRSdelcpcuts(prob, itype, interp, ncuts, mcutind)
end

"""

    getcutlist(prob::XpressProblem, itype, interp, ncuts, maxcuts, mcutind)

*Purpose*

Retrieves a list of cut pointers for the
cuts active at the current
node.

*Synopsis*

int XPRS_CC XPRSgetcutlist(XPRSprob prob, int itype, int interp, int *ncuts, int size, XPRScut mcutind[]);

*Arguments*

`prob`: The current problem.
`itype`: User defined type of the cuts to be returned. A value of
`-1 indicates return all active cuts.`: interp
`Way in which the cut type is interpreted:`: -1
`get all cuts;`: 1
`treat cut types as numbers;`: 2
`treat cut types as bit maps - get cut if any bit matches any bit set in`: itype;
`3`: treat cut types as bit maps - get cut if all bits match those set in
`itype.`: ncuts
`Pointer to the integer where the number of active cuts of type`: itype will be returned.
`size`: Maximum number of cuts to be retrieved.
`mcutind`: Array of length

*Example*



*Related*

XPRSgetcpcutlist,
XPRSgetcpcuts, Section
Working with the Cut Manager.
"""
function getcutlist(prob::XpressProblem, itype, interp, ncuts, maxcuts, mcutind)
    @checked Lib.XPRSgetcutlist(prob, itype, interp, ncuts, maxcuts, mcutind)
end

"""

    getcpcutlist(prob::XpressProblem, itype, interp, delta, ncuts, maxcuts, mcutind, dviol)

*Purpose*

Returns a list of cut indices from the
cut pool.

*Synopsis*

int XPRS_CC XPRSgetcpcutlist(XPRSprob prob, int itype, int interp, double delta, int *ncuts, int size, XPRScut mcutind[], double dviol[]);

*Arguments*

`prob`: The current problem.
`itype`: The user defined type of the cuts to be returned.
`interp`: Way in which the cut type is interpreted:
`-1`: get all cuts;
`1`: treat cut types as numbers;
`2`: treat cut types as bit maps - get cut if any bit matches any bit set in
`itype;`: 3
`treat cut types as bit maps - get cut if all bits match those set in`: itype.
`delta`: Only those cuts with a signed violation greater than delta will be returned.
`ncuts`: Pointer to the integer where the number of cuts of type
`itype in the cut pool will be returned.`: size
`Maximum number of cuts to be returned.`: mcutind
`Array of length`: size where the pointers to the cuts will be returned.
`dviol`: Double array of length

*Example*



*Related*

XPRSdelcpcuts,
XPRSgetcpcuts,
XPRSgetcutlist,
XPRSloadcuts,
XPRSgetcutmap,
XPRSgetcutslack, Section
Working with the Cut Manager.
"""
function getcpcutlist(prob::XpressProblem, itype, interp, delta, ncuts, maxcuts, mcutind, dviol)
    @checked Lib.XPRSgetcpcutlist(prob, itype, interp, delta, ncuts, maxcuts, mcutind, dviol)
end

"""

    getcpcuts(prob::XpressProblem, mindex, ncuts, size, mtype, qrtype, mstart, mcols, dmatval, drhs)

*Purpose*

Returns cuts from the
cut pool. A list of cut pointers in the array
mindex must be passed to the routine. The columns and elements of the cut will be returned in the regions pointed to by the
mcols and
dmatval parameters. The columns and elements will be stored contiguously and the starting point of each cut will be returned in the region pointed to by the
mstart parameter.

*Synopsis*

int XPRS_CC XPRSgetcpcuts(XPRSprob prob, const XPRScut mindex[], int ncuts, int size, int mtype[], char qrtype[], int mstart[], int mcols[], double dmatval[], double drhs[]);

*Arguments*

`prob`: The current problem.
`mindex`: Array of length
`ncuts containing the pointers to the cuts.`: ncuts
`Number of cuts to be returned.`: size
`Maximum number of column indices of the cuts to be returned.`: mtype
`Integer array of length at least`: ncuts where the cut types will be returned. May be NULL if not required.
`qrtype`: Character array of length at least
`ncuts where the sense of the cuts (`: L,
`G, or`: E) will be returned. May be NULL if not required.
`mstart`: Integer array of length at least
`ncuts+1 containing the offsets into the`: mcols and
`dmatval arrays. The last element indicates where cut`: ncuts+1 would start. May be NULL if not required.
`mcols`: Integer array of length
`size where the column indices of the cuts will be returned. May be NULL if not required.`: dmatval
`Double array of length`: size where the matrix values will be returned. May be NULL if not required.
`drhs`: Double array of length at least

*Example*



*Related*

XPRSgetcpcutlist,
XPRSgetcutlist,
Working with the Cut Manager.
"""
function getcpcuts(prob::XpressProblem, mindex, ncuts, size, mtype, qrtype, mstart, mcols, dmatval, drhs)
    @checked Lib.XPRSgetcpcuts(prob, mindex, ncuts, size, mtype, qrtype, mstart, mcols, dmatval, drhs)
end

function getcpcuts64(prob::XpressProblem, mindex, ncuts, size, mtype, qrtype, mstart, mcols, dmatval, drhs)
    @checked Lib.XPRSgetcpcuts64(prob, mindex, ncuts, size, mtype, qrtype, mstart, mcols, dmatval, drhs)
end

"""

    loadcuts(prob::XpressProblem, itype, interp, ncuts, mcutind)

*Purpose*

Loads cuts from the
cut pool into the matrix. Without calling
XPRSloadcuts the cuts will remain in the cut pool but will not be active at the
node. Cuts loaded at a node remain active at all descendant nodes unless they are deleted using
XPRSdelcuts.

*Synopsis*

int XPRS_CC XPRSloadcuts(XPRSprob prob, int itype, int interp, int ncuts, const XPRScut mcutind[]);

*Arguments*

`prob`: The current problem.
`itype`: Cut type.
`interp`: The way in which the cut type is interpreted:
`-1`: load all cuts;
`1`: treat cut types as numbers;
`2`: treat cut types as bit maps - load cut if any bit matches any bit set in
`itype;`: 3
`treat cut types as bit maps -`: 0 load cut if all bits match those set in
`itype.`: ncuts
`Number of cuts to load.`: mcutind
`Array of length`: ncuts containing pointers to the cuts to be loaded into the matrix. These are pointers returned by either
`XPRSstorecuts or`: XPRSgetcpcutlist.

*Example*



*Related*

XPRSaddcuts,
XPRSdelcpcuts,
XPRSdelcuts,
XPRSgetcpcutlist,
Working with the Cut Manager.
"""
function loadcuts(prob::XpressProblem, itype, interp, ncuts, mcutind)
    @checked Lib.XPRSloadcuts(prob, itype, interp, ncuts, mcutind)
end

"""

    storecuts(prob::XpressProblem, ncuts, nodupl, mtype, qrtype, drhs, mstart, mindex, mcols, dmatval)

*Purpose*

Stores cuts into the
cut pool, but does not apply them to the current node. These cuts must be explicitly loaded into the matrix using
XPRSloadcuts or
XPRSsetbranchcuts before they become active.

*Synopsis*

int XPRS_CC XPRSstorecuts(XPRSprob prob, int ncuts, int nodupl, const int mtype[], const char qrtype[], const double drhs[], const int mstart[], XPRScut mindex[], const int mcols[], const double dmatval[]);

*Arguments*

`prob`: The current problem.
`ncuts`: Number of cuts to add.
`nodupl`: 0
`do not exclude duplicates from the cut pool;`: 1
`duplicates are to be excluded from the cut pool;`: 2
`duplicates are to be excluded from the cut pool, ignoring cut type.`: mtype
`Integer array of length`: ncuts containing the cut types. The cut types can be any integer and are used to identify the cuts.
`qrtype`: Character array of length
`ncuts containing the row types:`: L
`indicates a â¤ row;`: E
`indicates an = row;`: G
`indicates a â¥ row.`: drhs
`Double array of length`: ncuts containing the right hand side elements for the cuts.
`mstart`: Integer array containing offsets into the
`mcols and`: dmtval arrays indicating the start of each cut. This array is of length
`ncuts+1 with the last element`: mstart[ncuts] being where cut
`ncuts+1 would start.`: mindex
`Array of length`: ncuts where the pointers to the cuts will be returned.
`mcols`: Integer array of length
`mstart[ncuts] containing the column indices in the cuts.`: dmatval
`Double array of length`: mstart[ncuts] containing the matrix values for the cuts.

*Example*



*Related*

XPRSloadcuts
XPRSsetbranchcuts,
XPRSaddcbestimate,
XPRSaddcbsepnode,
Working with the Cut Manager.
"""
function storecuts(prob::XpressProblem, ncuts, nodupl, mtype, qrtype, drhs, mstart, mindex, mcols, dmatval)
    @checked Lib.XPRSstorecuts(prob, ncuts, nodupl, mtype, qrtype, drhs, mstart, mindex, mcols, dmatval)
end

function storecuts64(prob::XpressProblem, ncuts, nodupl, mtype, qrtype, drhs, mstart, mindex, mcols, dmatval)
    @checked Lib.XPRSstorecuts64(prob, ncuts, nodupl, mtype, qrtype, drhs, mstart, mindex, mcols, dmatval)
end

"""

    presolverow(prob::XpressProblem, qrtype, nzo, mcolso, dvalo, drhso, maxcoeffs, nzp, mcolsp, dvalp, drhsp, status)

*Purpose*

Presolves a row formulated in terms of the original variables such that it can be added to a presolved matrix.

*Synopsis*

int XPRS_CC XPRSpresolverow(XPRSprob prob, char qrtype, int nzo, const int mcolso[], const double dvalo[], double drhso, int maxcoeffs, int * nzp, int mcolsp[], double dvalp[], double * drhsp, int * status);

*Arguments*

`prob`: The current problem.
`qrtype`: The type of the row:
`L`: indicates a â¤ row;
`G`: indicates a â¥ row.
`nzo`: Number of elements in the
`mcolso and`: dvalo arrays.
`mcolso`: Integer array of length
`nzo containing the column indices of the row to presolve.`: dvalo
`Double array of length`: nzo containing the non-zero coefficients of the row to presolve.
`drhso`: The right-hand side constant of the row to presolve.
`maxcoeffs`: Maximum number of elements to return in the
`mcolsp and`: dvalp arrays.
`nzp`: Pointer to the integer where the number of elements in the
`mcolsp and`: dvalp arrays will be returned.
`mcolsp`: Integer array which will be filled with the column indices of the presolved row. It must be allocated to hold at least
`COLS elements.`: dvalp
`Double array which will be filled with the coefficients of the presolved row. It must be allocated to hold at least`: COLS elements.
`drhsp`: Pointer to the double where the presolved right-hand side will be returned.
`status`: Status of the presolved row:
`-3`: Failed to presolve the row due to presolve dual reductions;
`-2`: Failed to presolve the row due to presolve duplicate column reductions;
`-1`: Failed to presolve the row due to an error. Check the Optimizer error code for the cause;
`0`: The row was successfully presolved;
`1`: The row was presolved, but may be relaxed.

*Example*

Suppose we want to add the row 2x
1 + x
2 â¤ 1 to our presolved matrix. This could be done in the following way:

*Related*

XPRSaddcuts,
XPRSloadsecurevecs,
XPRSsetbranchcuts,
XPRSstorecuts.
"""
function presolverow(prob::XpressProblem, qrtype, nzo, mcolso, dvalo, drhso, maxcoeffs, nzp, mcolsp, dvalp, drhsp, status)
    @checked Lib.XPRSpresolverow(prob, qrtype, nzo, mcolso, dvalo, drhso, maxcoeffs, nzp, mcolsp, dvalp, drhsp, status)
end

"""

    loadlpsol(prob::XpressProblem, _dx, _dslack, _dual, _dj, status)

*Purpose*

Loads an LP solution for the problem into the Optimizer.

*Synopsis*

int XPRS_CC XPRSloadlpsol(XPRSprob prob, double x[], double slack[], double dual[], double dj[], int *status);

*Arguments*

`prob`: The current problem.
`x`: Optional: Double array of length
`COLS (for the original problem and not the presolve problem) containing the values of the variables.`: slack
`Optional: double array of length`: ROWS containing the values of slack variables.
`dual`: Optional: double array of length
`ROWS containing the values of dual variables.`: dj
`Optional: double array of length`: COLS containing the values of reduced costs.
`status`: Pointer to an
`int where the status will be returned. The status is one of:`: 0
`Solution is loaded.`: 1

*Example*

This example loads a problem, loads a solution for the problem and then uses
XPRScrossoverlpsol to find a basic optimal solution.

*Related*

XPRSgetlpsol,
XPRScrossoverlpsol.
"""
function loadlpsol(prob::XpressProblem, _dx, _dslack, _dual, _dj, status)
    @checked Lib.XPRSloadlpsol(prob, _dx, _dslack, _dual, _dj, status)
end

"""

    loadmipsol(prob::XpressProblem, dsol, status)

*Purpose*

Loads a MIP solution for the problem into the Optimizer.

*Synopsis*

int XPRS_CC XPRSloadmipsol(XPRSprob prob, const double dsol[], int *status);

*Arguments*

`prob`: The current problem.
`dsol`: Double array of length
`COLS (for the original problem and not the presolve problem) containing the values of the variables.`: status
`Pointer to an`: int where the status will be returned. The status is one of:
`-1`: Solution rejected because an error occurred;
`0`: Solution accepted. When loading a solution before a MIP solve, the solution is always accepted. See Further Information below.
`1`: Solution rejected because it is infeasible;
`2`: Solution rejected because it is cut off;
`3`: Solution rejected because the LP reoptimization was interrupted.

*Example*

This example loads a problem and then loads a solution found previously for the problem to help speed up the MIP search:

*Related*

XPRSgetmipsol,
XPRSaddcboptnode.
"""
function loadmipsol(prob::XpressProblem, dsol, status)
    @checked Lib.XPRSloadmipsol(prob, dsol, status)
end

"""

    addmipsol(prob::XpressProblem, ilength, mipsolval, mipsolcol, solname)

*Purpose*

Adds a new feasible, infeasible or partial MIP solution for the problem to the Optimizer.

*Synopsis*

int XPRS_CC XPRSaddmipsol(XPRSprob prob, int ilength, const double mipsolval[], const int mipsolcol[], const char* solname);

*Arguments*

`prob`: The current problem.
`ilength`: Number of columns for which a value is provided.
`mipsolval`: Double array of length
`ilength containing solution values.`: mipsolcol
`Optional integer array of length`: ilength containing the column indices for the solution values provided in
`mipsolval. Can be`: NULL when
`ilength is equal to`: COLS, in which case it is assumed that
`mipsolval provides a complete solution vector.`: solname

*Example*



*Related*

XPRSaddcbusersolnotify,
XPRSaddcboptnode.
"""
function addmipsol(prob::XpressProblem, ilength, mipsolval, mipsolcol, solname)
    @checked Lib.XPRSaddmipsol(prob, ilength, mipsolval, mipsolcol, solname)
end

"""

    storebounds(prob::XpressProblem, nbnds, mcols, qbtype, dbnd, mindex)

*Purpose*

Stores bounds for node separation using user separate callback function.

*Synopsis*

int XPRS_CC XPRSstorebounds(XPRSprob prob, int nbnds, const int mcols[], const char qbtype[], const double dbds[], void **mindex);

*Arguments*

`prob`: The current problem.
`nbnds`: Number of bounds to store.
`mcols`: Array containing the column indices.
`qbtype`: Array containing the bounds types:
`U`: indicates an upper bound;
`L`: indicates a lower bound.
`dbds`: Array containing the bound values.
`mindex`: Pointer that the user will use to reference the stored bounds for the Optimizer in

*Example*

This example defines a user separate callback function for the global search:

*Related*

XPRSsetbranchbounds,
XPRSaddcbestimate,
XPRSaddcbsepnode.
"""
function storebounds(prob::XpressProblem, nbnds, mcols, qbtype, dbnd, mindex)
    @checked Lib.XPRSstorebounds(prob, nbnds, mcols, qbtype, dbnd, mindex)
end

"""

    setbranchcuts(prob::XpressProblem, nbcuts, mindex)

*Purpose*

Specifies the pointers to cuts in the cut pool that are to be applied in order to branch on a user
global entity. This routine can only be called from the user separate callback function,
XPRSaddcbsepnode.

*Synopsis*

int XPRS_CC XPRSsetbranchcuts(XPRSprob prob, int ncuts, const XPRScut mindex[]);

*Arguments*

`prob`: The current problem.
`ncuts`: Number of cuts to apply.
`mindex`: Array containing the pointers to the cuts in the cut pool that are to be applied. Typically obtained from

*Example*



*Related*

XPRSgetcpcutlist,
XPRSaddcbestimate,
XPRSaddcbsepnode,
XPRSstorecuts, Section
Working with the Cut Manager.
"""
function setbranchcuts(prob::XpressProblem, nbcuts, mindex)
    @checked Lib.XPRSsetbranchcuts(prob, nbcuts, mindex)
end

"""

    setbranchbounds(prob::XpressProblem, mindex)

*Purpose*

Specifies the bounds previously stored using
XPRSstorebounds that are to be applied in order to branch on a user
global entity. This routine can only be called from the user separate callback function,
XPRSaddcbsepnode.

*Synopsis*

int XPRS_CC XPRSsetbranchbounds(XPRSprob prob, void *mindex);

*Arguments*

`prob`: The current problem.
`mindex`: Pointer previously defined in a call to

*Example*

This example defines a user separate callback function for the global search:

*Related*

XPRSloadcuts,
XPRSaddcbestimate,
XPRSaddcbsepnode,
XPRSstorebounds, Section
Working with the Cut Manager.
"""
function setbranchbounds(prob::XpressProblem, mindex)
    @checked Lib.XPRSsetbranchbounds(prob, mindex)
end

"""

    getlasterror(prob::XpressProblem, errmsg)

*Purpose*

Returns the error message corresponding to the last error encountered by a library function.

*Synopsis*

int XPRS_CC XPRSgetlasterror(XPRSprob prob, char *errmsg);

*Arguments*

`prob`: The current problem.
`errmsg`: A 512 character buffer where the last error message will be returned.

*Example*

The following shows how this function might be used in error-checking:

*Related*

ERRORCODE,
XPRSaddcbmessage,
XPRSsetlogfile, Chapter
Return Codes and Error Messages.
"""
function getlasterror(prob::XpressProblem, errmsg)
    @checked Lib.XPRSgetlasterror(prob, errmsg)
end

"""

    basiscondition(prob::XpressProblem, condnum, scondnum)

*Purpose*

This function is deprecated, and will be removed in future releases. Please use the
XPRSbasisstability function instead.
Calculates the condition number of the current basis after solving the LP relaxation.

*Synopsis*

int XPRS_CC XPRSbasiscondition(XPRSprob prob, double *condnum, double *scondnum);

*Arguments*

`prob`: The current problem.
`condnum`: The returned condition number of the current basis.
`scondnum`: The returned condition number of the current basis for the scaled problem.

*Example*

Print the condition number after optimizing a problem.

*Related*


"""
function basiscondition(prob::XpressProblem, condnum, scondnum)
    @checked Lib.XPRSbasiscondition(prob, condnum, scondnum)
end

"""

    getmipsol(prob::XpressProblem, _dx, _dslack)

*Purpose*

Used to obtain the
solution values of the last MIP solution that was found.

*Synopsis*

int XPRS_CC XPRSgetmipsol(XPRSprob prob, double x[], double slack[]);

*Arguments*

`prob`: The current problem.
`x`: Double array of length
`COLS where the values of the primal variables will be returned. May be`: NULL if not required.
`slack`: Double array of length
`ROWS where the values of the slack variables will be returned. May be`: NULL if not required.

*Example*

The following sequence of commands will get the solution (
x) of the last MIP solution for a problem:

*Related*

XPRSgetmipsolval,
XPRSgetpresolvesol,
XPRSwriteprtsol,
XPRSwritesol.
"""
function getmipsol(prob::XpressProblem, _dx, _dslack)
    @checked Lib.XPRSgetmipsol(prob, _dx, _dslack)
end

"""

    getlpsol(prob::XpressProblem, _dx, _dslack, _dual, _dj)

*Purpose*

Used to obtain the LP solution values following optimization.

*Synopsis*

int XPRS_CC XPRSgetlpsol(XPRSprob prob, double x[], double slack[], double dual[], double dj[]);

*Arguments*

`prob`: The current problem.
`x`: Double array of length
`COLS where the values of the primal variables will be returned. May be`: NULL if not required.
`slack`: Double array of length
`ROWS where the values of the slack variables will be returned. May be`: NULL if not required.
`dual`: Double array of length
`ROWS where the values of the dual variables (`: cBTB-1) will be returned. May be
`NULL if not required.`: dj
`Double array of length`: COLS where the reduced cost for each variable (
`cT-cBTB-1A) will be returned. May be`: NULL if not required.

*Example*

The following sequence of commands will get the LP solution (
x) at the top node of a MIP and the optimal MIP solution (
y):

*Related*

XPRSgetlpsolval,
XPRSgetpresolvesol,
XPRSgetmipsol,
XPRSwriteprtsol,
XPRSwritesol.
"""
function getlpsol(prob::XpressProblem, _dx, _dslack, _dual, _dj)
    @checked Lib.XPRSgetlpsol(prob, _dx, _dslack, _dual, _dj)
end

"""

    postsolve(prob::XpressProblem)

*Purpose*

Postsolve the current matrix when it is in a presolved state.

*Synopsis*

int XPRS_CC XPRSpostsolve(XPRSprob prob);

*Arguments*

`prob`: The current problem.

*Example*



*Related*

XPRSlpoptimize,
XPRSmipoptimize
"""
function postsolve(prob::XpressProblem)
    @checked Lib.XPRSpostsolve(prob)
end

"""

    delsets(prob::XpressProblem, nsets, msindex)

*Purpose*

Delete sets from a
problem.

*Synopsis*

int XPRS_CC XPRSdelsets(XPRSprob prob, int nsets, const int mindex[]);

*Arguments*

`prob`: The current problem.
`nsets`: Number of sets to delete.
`mindex`: An integer array of length

*Example*

In this example, sets
0 and
2 are deleted from the problem:

*Related*

XPRSaddsets.
"""
function delsets(prob::XpressProblem, nsets, msindex)
    @checked Lib.XPRSdelsets(prob, nsets, msindex)
end

"""

    addsets(prob::XpressProblem, newsets, newnz, qstype, msstart, mscols, dref)

*Purpose*

Allows
sets to be added to the problem after passing it to the Optimizer using the input routines.

*Synopsis*

int XPRS_CC XPRSaddsets(XPRSprob prob, int newsets, int newnz, const char qrtype[], const int msstart[], const int mclind[], const double dref[]);

*Arguments*

`prob`: The current problem.
`newsets`: Number of new sets.
`newnz`: Number of new nonzeros in the added sets.
`qrtype`: Character array of length newsets containing the set types:
`1`: indicates a SOS1;
`2`: indicates a SOS2;
`msstart`: Integer array of length
`newsets containing the offsets in the`: mclind and
`dref arrays of the start of the elements for each set.`: mclind
`Integer array of length`: newnz containing the (contiguous) column indices for the elements in each set.
`dref`: Double array of length

*Example*



*Related*

XPRSdelsets.
"""
function addsets(prob::XpressProblem, newsets, newnz, qstype, msstart, mscols, dref)
    @checked Lib.XPRSaddsets(prob, newsets, newnz, qstype, msstart, mscols, dref)
end

function addsets64(prob::XpressProblem, newsets, newnz, qstype, msstart, mscols, dref)
    @checked Lib.XPRSaddsets64(prob, newsets, newnz, qstype, msstart, mscols, dref)
end

"""

    strongbranch(prob::XpressProblem, nbnds, _mindex, _sboundtype, _dbnd, itrlimit, _dsbobjval, _msbstatus)

*Purpose*

Performs strong branching iterations on all specified bound changes. For each candidate bound change,
XPRSstrongbranch performs dual simplex iterations starting from the current optimal solution of the base LP, and returns both the status and objective value reached after these iterations.

*Synopsis*

int XPRS_CC XPRSstrongbranch(XPRSprob prob, const int nbnds, const int mbndind[], const char cbndtype[], const double dbndval[], const int itrlimit, double dsobjval[], int msbstatus[]);

*Arguments*

`prob`: The current problem.
`nbnds`: Number of bound changes to try.
`mbndind`: Integer array of size
`nbnds containing the indices of the columns on which the bounds will change.`: cbndtype
`Character array of length`: nbnds indicating the type of bound to change:
`U`: indicates change the upper bound;
`L`: indicates change the lower bound;
`B`: indicates change both bounds, i.e. fix the column.
`dbndval`: Double array of length
`nbnds giving the new bound values.`: itrlimit
`Maximum number of LP iterations to perform for each bound change.`: dsobjval
`Objective value of each LP after performing the strong branching iterations.`: msbstatus
`Status of each LP after performing the strong branching iterations, as detailed for the`: LPSTATUS attribute.

*Example*

Suppose that the current LP relaxation has two integer columns (columns
0 and
1 which are fractionals at 0.3 and 1.5, respectively, and we want to perform strong branching in order to choose which to branch on. This could be done in the following way:

*Related*


"""
function strongbranch(prob::XpressProblem, nbnds::Int, _mindex::Vector{Int}, _sboundtype, _dbnd, itrlimit, _dsbobjval, _msbstatus)
    @checked Lib.XPRSstrongbranch(prob, nbnds, _mindex, _sboundtype, _dbnd, itrlimit, _dsbobjval, _msbstatus)
end

"""

    estimaterowdualranges(prob::XpressProblem, nRows, rowIndices, iterationLimit, minDualActivity, maxDualActivity)

*Purpose*

Performs a dual side range sensitivity analysis, i.e. calculates estimates for the possible ranges for dual values.

*Synopsis*

int XPRS_CC XPRSestimaterowdualranges(XPRSprob prob, const int nRows, const int rowIndices[], const int iterationLimit, double minDualActivity[], double maxDualActivity[]);

*Arguments*

`prob`: The current problem.
`nRows`: The number of rows to analyze.
`rowIndices`: Row indices to analyze.
`iterationLimit`: Effort limit expressed as simplex iterations per row.
`minDualActivity`: Estimated lower bounds on the possible dual ranges.
`maxDualActivity`: Estimated upper bounds on the possible dual ranges.

*Example*



*Related*

XPRSlpoptimize,
XPRSstrongbranch
"""
function estimaterowdualranges(prob::XpressProblem, nRows, rowIndices, iterationLimit, minDualActivity, maxDualActivity)
    @checked Lib.XPRSestimaterowdualranges(prob, nRows, rowIndices, iterationLimit, minDualActivity, maxDualActivity)
end

"""

    getprimalray(prob::XpressProblem, _dpray, _hasray)

*Purpose*

Retrieves a primal ray (primal unbounded direction) for the current problem, if the problem is found to be unbounded.

*Synopsis*

int XPRS_CC XPRSgetprimalray(XPRSprob prob, double dray[], int *hasRay);

*Arguments*

`prob`: The current problem.
`dray`: Double array of length
`COLS to hold the ray. May be NULL if not required.`: hasRay

*Example*

The following code tries to retrieve a primal ray:

*Related*

XPRSgetdualray.
"""
function getprimalray(prob::XpressProblem, _dpray, _hasray)
    @checked Lib.XPRSgetprimalray(prob, _dpray, _hasray)
end

"""

    getdualray(prob::XpressProblem, _ddray, _hasray)

*Purpose*

Retrieves a dual ray (dual unbounded direction) for the current problem, if the problem is found to be infeasible.

*Synopsis*

int XPRS_CC XPRSgetdualray(XPRSprob prob, double dray[], int *hasRay);

*Arguments*

`prob`: The current problem.
`dray`: Double array of length
`ROWS to hold the ray. May be NULL if not required.`: hasRay

*Example*

The following code tries to retrieve a dual ray:

*Related*

XPRSgetprimalray.
"""
function getdualray(prob::XpressProblem, _ddray, _hasray)
    @checked Lib.XPRSgetdualray(prob, _ddray, _hasray)
end

"""

    setmessagestatus(prob::XpressProblem, errcode, bEnabledStatus)

*Purpose*

Manages suppression of messages.

*Synopsis*

int XPRS_CC XPRSsetmessagestatus(XPRSprob prob, int errcode, int status);

*Arguments*

`prob`: The problem for which message
`errcode is to have its suppression status changed; pass`: NULL if the message should have the status apply globally to all problems.
`errcode`: The id number of the message. Refer to the section
`Return Codes and Error Messages for a list of possible message numbers.`: status
`Non-zero if the message is not suppressed;`: 0 otherwise. If a value for
`status is not supplied in the command-line call then the console Optimizer prints the value of the suppression status to screen i.e., non-zero if the message is not suppressed;`: 0 otherwise.

*Example*

Attempting to optimize a problem that has no matrix loaded gives error 91. The following code uses
XPRSsetmessagestatus to suppress the error message:

*Related*

XPRSgetmessagestatus.
"""
function setmessagestatus(prob::XpressProblem, errcode, bEnabledStatus)
    @checked Lib.XPRSsetmessagestatus(prob, errcode, bEnabledStatus)
end

"""

    getmessagestatus(prob::XpressProblem, errcode, bEnabledStatus)

*Purpose*

Retrieves the current suppression status of a message.

*Synopsis*

int XPRS_CC XPRSgetmessagestatus(XPRSprob prob, int errcode, int *status);

*Arguments*

`prob`: The problem to check for the suppression status of the message error code. Use
`NULL to check for the global suppression status of the message errcode.`: errcode
`The id number of the message. Refer to Chapter`: Return Codes and Error Messages for a list of possible message numbers.
`status`: Non-zero if the message is not suppressed;

*Example*



*Related*

XPRSsetmessagestatus.
"""
function getmessagestatus(prob::XpressProblem, errcode, bEnabledStatus)
    @checked Lib.XPRSgetmessagestatus(prob, errcode, bEnabledStatus)
end

"""

    repairweightedinfeas(prob::XpressProblem, scode, lrp_array, grp_array, lbp_array, ubp_array, second_phase, delta, optflags)

*Purpose*

By relaxing a set of selected constraints and bounds of an infeasible problem, it attempts to identify a 'solution' that violates the selected set of constraints and bounds minimally, while satisfying all other constraints and bounds. Among such solution candidates, it selects one that is optimal regarding to the original objective function. For the console version, see
REPAIRINFEAS.

*Synopsis*

int XPRS_CC XPRSrepairweightedinfeas(XPRSprob prob, int * scode, const double lrp_array[], const double grp_array[], const double lbp_array[], const double ubp_array[], char phase2, double delta, const char *optflags);

*Arguments*

`prob`: The current problem.
`scode`: The status after the relaxation:
`1`: relaxed problem is infeasible;
`2`: relaxed problem is unbounded;
`3`: solution of the relaxed problem regarding the original objective is nonoptimal;
`4`: error (when return code is nonzero);
`5`: numerical instability;
`6`: analysis of an infeasible relaxation was performed, but the relaxation is feasible.
`lrp_array`: Array of size
`ROWS containing the preferences for relaxing the less or equal side of row.`: grp_array
`Array of size`: ROWS containing the preferences for relaxing the greater or equal side of a row.
`lbp_array`: Array of size
`COLS containing the preferences for relaxing lower bounds.`: ubp_array
`Array of size`: COLS containing preferences for relaxing upper bounds.
`phase2`: Controls the second phase of optimization:
`o`: use the objective sense of the original problem (default);
`x`: maximize the relaxed problem using the original objective;
`f`: skip optimization regarding the original objective;
`n`: minimize the relaxed problem using the original objective;
`i`: if the relaxation is infeasible, generate an irreducible infeasible subset for the analys of the problem;
`a`: if the relaxation is infeasible, generate all irreducible infeasible subsets for the analys of the problem.
`delta`: The relaxation multiplier in the second phase -1.
`optflags`: Specifies flags to be passed to the Optimizer.

*Example*



*Related*

XPRSrepairinfeas (
REPAIRINFEAS),
XPRSrepairweightedinfeasbounds,
The Infeasibility Repair Utility.
"""
function repairweightedinfeas(prob::XpressProblem, scode, lrp_array, grp_array, lbp_array, ubp_array, second_phase, delta, optflags)
    @checked Lib.XPRSrepairweightedinfeas(prob, scode, lrp_array, grp_array, lbp_array, ubp_array, second_phase, delta, optflags)
end

"""

    repairweightedinfeasbounds(prob::XpressProblem, scode, lrp_array, grp_array, lbp_array, ubp_array, lrb_array, grb_array, lbb_array, ubb_array, second_phase, delta, optflags)

*Purpose*

An extended version of
XPRSrepairweightedinfeas that allows for bounding the level of relaxation allowed.

*Synopsis*

int XPRS_CC XPRSrepairweightedinfeasbounds(XPRSprob prob, int * scode, const double lrp_array[], const double grp_array[], const double lbp_array[], const double ubp_array[], const double lrb_array[], const double grb_array[], const double lbb_array[], const double ubb_array[], char phase2, double delta, const char *optflags);

*Arguments*

`prob`: The current problem.
`scode`: The status after the relaxation:
`1`: relaxed problem is infeasible;
`2`: relaxed problem is unbounded;
`3`: solution of the relaxed problem regarding the original objective is nonoptimal;
`4`: error (when return code is nonzero);
`5`: numerical instability;
`6`: analysis of an infeasible relaxation was performed, but the relaxation is feasible.
`lrp_array`: Array of size
`ROWS containing the preferences for relaxing the less or equal side of row. For the console use`: -lrp value.
`grp_array`: Array of size
`ROWS containing the preferences for relaxing the greater or equal side of a row. For the console use`: -grp value.
`lbp_array`: Array of size
`COLS containing the preferences for relaxing lower bounds. For the console use`: -lbp value.
`ubp_array`: Array of size
`COLS containing preferences for relaxing upper bounds. For the console use`: -ubp value.
`lrb_array`: Array of size
`ROWS containing the upper bounds on the amount the less or equal side of a row can be relaxed. For the console use`: -lrb value.
`grb_array`: Array of size
`ROWS containing the upper bounds on the amount the greater or equal side of a row can be relaxed. For the console use`: -grb value.
`lbb_array`: Array of size
`COLS containing the upper bounds on the amount the lower bounds can be relaxed. For the console use`: -lbb value.
`ubb_array`: Array of size
`COLS containing the upper bounds on the amount the upper bounds can be relaxed. For the console use`: -ubb value.
`phase2`: Controls the second phase of optimization:
`o`: use the objective sense of the original problem (default);
`x`: maximize the relaxed problem using the original objective;
`f`: skip optimization regarding the original objective;
`n`: minimize the relaxed problem using the original objective;
`i`: if the relaxation is infeasible, generate an irreducible infeasible subset for the analys of the problem;
`a`: if the relaxation is infeasible, generate all irreducible infeasible subsets for the analys of the problem.
`delta`: The relaxation multiplier in the second phase -1.
`optflags`: Specifies flags to be passed to the Optimizer.
`r`: If a summary of the violated variables and constraints should be printed after the relaxed solution is determined.

*Example*



*Related*

XPRSrepairinfeas (
REPAIRINFEAS),
The Infeasibility Repair Utility.
"""
function repairweightedinfeasbounds(prob::XpressProblem, scode, lrp_array, grp_array, lbp_array, ubp_array, lrb_array, grb_array, lbb_array, ubb_array, second_phase, delta, optflags)
    @checked Lib.XPRSrepairweightedinfeasbounds(prob, scode, lrp_array, grp_array, lbp_array, ubp_array, lrb_array, grb_array, lbb_array, ubb_array, second_phase, delta, optflags)
end

"""

    repairinfeas(prob::XpressProblem, scode, ptype, phase2, globalflags, lrp, grp, lbp, ubp, delta)

*Purpose*

Provides a simplified interface for
XPRSrepairweightedinfeas.

*Synopsis*

int XPRS_CC XPRSrepairinfeas (XPRSprob prob, int *scode, char pflags, char oflags, char gflags, double lrp, double grp, double lbp, double ubp, double delta);

*Arguments*

`prob`: The current problem.
`scode`: The status after the relaxation:
`0`: relaxed optimum found;
`1`: relaxed problem is infeasible;
`2`: relaxed problem is unbounded;
`3`: solution of the relaxed problem regarding the original objective is nonoptimal;
`4`: error (when return code is nonzero);
`5`: numerical instability;
`6`: analysis of an infeasible relaxation was performed, but the relaxation is feasible.
`pflags`: The type of penalties created from the preferences:
`c`: each penalty is the reciprocal of the preference (default);
`s`: the penalties are placed in the scaled problem.
`oflags`: Controls the second phase of optimization:
`o`: use the objective sense of the original problem (default);
`x`: maximize the relaxed problem using the original objective;
`f`: skip optimization regarding the original objective;
`n`: minimize the relaxed problem using the original objective;
`i`: if the relaxation is infeasible, generate an irreducible infeasible subset for the analys of the problem;
`a`: if the relaxation is infeasible, generate all irreducible infeasible subsets for the analys of the problem.
`gflags`: Specifies if the global search should be done:
`g`: do the global search (default);
`l`: solve as a linear model ignoring the discreteness of variables.
`lrp`: Preference for relaxing the less or equal side of row.
`grp`: Preference for relaxing the greater or equal side of a row.
`lbp`: Preferences for relaxing lower bounds.
`ubp`: Preferences for relaxing upper bounds.
`delta`: The relaxation multiplier in the second phase -1. For console use
`-d value. A positive value means a relative relaxation by multiplying the first phase objective with (`: delta-1), while a negative value means an absolute relaxation, by adding

*Example*

READPROB MYPROB.LP
REPAIRINFEAS -a -d 0.002

*Related*

XPRSrepairweightedinfeas,
The Infeasibility Repair Utility.
"""
function repairinfeas(prob::XpressProblem, scode, ptype, phase2, globalflags, lrp, grp, lbp, ubp, delta)
    @checked Lib.XPRSrepairinfeas(prob, scode, ptype, phase2, globalflags, lrp, grp, lbp, ubp, delta)
end

"""

    getcutslack(prob::XpressProblem, cut, dslack)

*Purpose*

Used to calculate the slack value of a cut with respect to the current LP relaxation solution. The slack is calculated from the cut itself, and might be requested for any cut (even if it is not currently loaded into the problem).

*Synopsis*

int XPRS_CC XPRSgetcutslack(XPRSprob prob, XPRScut cut, double* dslack);

*Arguments*

`prob`: The current problem.
`cuts`: Pointer of the cut for which the slack is to be calculated.
`dslack`: Double pointer where the value of the slack is returned.

*Example*



*Related*

XPRSgetcpcutlist,
XPRSdelcpcuts,
XPRSgetcutlist,
XPRSloadcuts,
XPRSgetcutmap,
XPRSgetcpcuts, Section
Working with the Cut Manager.
"""
function getcutslack(prob::XpressProblem, cut, dslack)
    @checked Lib.XPRSgetcutslack(prob, cut, dslack)
end

"""

    getcutmap(prob::XpressProblem, ncuts, cuts, cutmap)

*Purpose*

Used to return in which rows a list of cuts are currently loaded into the Optimizer. This is useful for example to retrieve the duals associated with active cuts.

*Synopsis*

int XPRS_CC XPRSgetcutmap(XPRSprob prob, int ncuts, const XPRScut cuts[], int cutmap[]);

*Arguments*

`prob`: The current problem.
`ncuts`: Number of cuts in the cuts array.
`cuts`: Pointer array to the cuts for which the row index is requested.
`cutmap`: Integer array of length

*Example*



*Related*

XPRSgetcpcutlist,
XPRSdelcpcuts,
XPRSgetcutlist,
XPRSloadcuts,
XPRSgetcutslack,
XPRSgetcpcuts, Section
Working with the Cut Manager.
"""
function getcutmap(prob::XpressProblem, ncuts, cuts, cutmap)
    @checked Lib.XPRSgetcutmap(prob, ncuts, cuts, cutmap)
end

"""

    basisstability(prob::XpressProblem, typecode, norm, ifscaled, dval)

*Purpose*

Calculates various measures for the stability of the current basis, including the basis condition number.

*Synopsis*

int XPRS_CC XPRSbasisstability(XPRSprob prob, int type, int norm, int ifscaled, double *dval);

*Arguments*

`prob`: The current problem.
`type`: 0
`Condition number of the basis.`: 1
`Stability measure for the solution relative to the current basis.`: 2
`Stability measure for the duals relative to the current basis.`: 3
`Stability measure for the right hand side relative to the current basis.`: 4
`Stability measure for the basic part of the objective relative to the current basis.`: norm
`0`: Use the infinity norm.
`1`: Use the 1 norm.
`2`: Use the Euclidian norm for vectors, and the Frobenius norm for matrices.
`ifscaled`: If the stability values are to be calculated in the scaled, or the unscaled matrix.
`dval`: Pointer to a double, where the calculated value is to be returned.
`flags`: x
`Stability measure for the solution and rightâhand side values relative to the current basis.`: d
`Stability measure for the duals and the basic part of the objective relative to the current basis.`: c
`Condition number of the basis (default).`: i
`Use the infinity norm (default).`: o
`Use the one norm.`: e
`Use the Euclidian norm for vectors, and the Frobenius norm for matrices.`: u

*Example*



*Related*


"""
function basisstability(prob::XpressProblem, typecode, norm, ifscaled::Bool, dval)
    @checked Lib.XPRSbasisstability(prob, typecode, norm, ifscaled, dval)
end

"""

    calcslacks(prob::XpressProblem, solution, calculatedslacks)

*Purpose*

Calculates the row slack values for a given solution.

*Synopsis*

int XPRS_CC XPRScalcslacks(XPRSprob prob, const double solution[], double calculatedslacks[]);

*Arguments*

`prob`: The current problem.
`solution`: Double array of length COLS that holds the solution to calculate the slacks for.
`calculatedslacks`: Double array of length ROWS in which the calculated row slacks are returned.

*Example*



*Related*

XPRScalcreducedcosts,
XPRScalcsolinfo,
XPRScalcobjective.
"""
function calcslacks(prob::XpressProblem, solution, calculatedslacks)
    @checked Lib.XPRScalcslacks(prob, solution, calculatedslacks)
end

"""

    calcreducedcosts(prob::XpressProblem, duals, solution, calculateddjs)

*Purpose*

Calculates the reduced cost values for a given (row) dual solution.

*Synopsis*

int XPRS_CC XPRScalcreducedcosts(XPRSprob prob, const double duals[], const double solution[], double calculateddjs[]);

*Arguments*

`prob`: The current problem.
`duals`: Double array of length ROWS that holds the dual solution to calculate the reduced costs for.
`solution`: Optional double array of length COLS that holds the primal solution. This is necessary for quadratic problems.
`calculateddjs`: Double array of length COLS in which the calculated reduced costs are returned.

*Example*



*Related*

XPRScalcslacks,
XPRScalcsolinfo,
XPRScalcobjective.
"""
function calcreducedcosts(prob::XpressProblem, duals, solution, calculateddjs)
    @checked Lib.XPRScalcreducedcosts(prob, duals, solution, calculateddjs)
end

"""

    calcobjective(prob::XpressProblem, solution, objective)

*Purpose*

Calculates the objective value of a given solution.

*Synopsis*

int XPRS_CC XPRScalcobjective(XPRSprob prob, const double solution[], double* objective);

*Arguments*

`prob`: The current problem.
`solution`: Double array of length COLS that holds the solution.
`objective`: Pointer to a double in which the calculated objective value is returned.

*Example*



*Related*

XPRScalcslacks,
XPRScalcsolinfo,
XPRScalcreducedcosts.
"""
function calcobjective(prob::XpressProblem, solution, objective)
    @checked Lib.XPRScalcobjective(prob, solution, objective)
end

"""

    refinemipsol(prob::XpressProblem, options, _sflags, solution, refined_solution, refinestatus)

*Purpose*

Executes the MIP solution refiner.

*Synopsis*

int XPRS_CC XPRSrefinemipsol(XPRSprob prob, int options, const char* flags, const double solution[], double refined_solution[], int* refinestatus);

*Arguments*

`prob`: The current problem.
`options`: Refinement options:
`0`: Reducing MIP fractionality is priority.
`1`: Reducing LP infeasibility is priority
`flags`: Flags passed to any optimization calls during refinement.
`solution`: The MIP solution to refine. Must be a valid MIP solution.
`refined_solution`: The refined MIP solution in case of success
`refinestatus`: Refinement results:
`0`: An error has occurred
`1`: The solution has been refined
`2`: Current solution meets target criteria
`3`: Solution cannot be refined

*Example*



*Related*

REFINEOPS.
"""
function refinemipsol(prob::XpressProblem, options, _sflags, solution, refined_solution, refinestatus)
    @checked Lib.XPRSrefinemipsol(prob, options, _sflags, solution, refined_solution, refinestatus)
end

"""

    calcsolinfo(prob::XpressProblem, solution, dual, Property, Value)

*Purpose*

Calculates the required property of a solution, like maximum infeasibility of a given primal and dual solution.

*Synopsis*

int XPRS_CC XPRScalcsolinfo(XPRSprob prob, const double solution[], const double dual[], int Property, double* Value);

*Arguments*

`prob`: The current problem.
`solution`: Double array of length COLS that holds the solution.
`dual`: Double array of length ROWS that holds the dual solution.
`Property`: XPRS_SOLINFO_ABSPRIMALINFEAS
`the calculated maximum absolute primal infeasibility is returned.`: XPRS_SOLINFO_RELPRIMALINFEAS
`the calculated maximum relative primal infeasibility is returned.`: XPRS_SOLINFO_ABSDUALINFEAS
`the calculated maximum absolute dual infeasibility is returned.`: XPRS_SOLINFO_RELDUALINFEAS
`the calculated maximum relative dual infeasibility is returned.`: XPRS_SOLINFO_MAXMIPFRACTIONAL
`the calculated maximum absolute MIP infeasibility (fractionality) is returned.`: Value

*Example*



*Related*

XPRScalcslacks,
XPRScalcobjective,
XPRScalcreducedcosts.
"""
function calcsolinfo(prob::XpressProblem, solution, dual, Property, Value)
    @checked Lib.XPRScalcsolinfo(prob, solution, dual, Property, Value)
end

"""

    getnamelist(prob::XpressProblem, _itype, _sbuff, names_len, names_len_reqd, first, last)

*Purpose*

Returns the names for the rows, columns or sets in a given range. The names will be returned in a character buffer, with no trailing whitespace and with each name being separated by a NULL character.

*Synopsis*

int XPRS_CC XPRSgetnamelist(XPRSprob prob, int type, char names[], int names_len, int * names_len_reqd, int first, int last);

*Arguments*

`prob`: The current problem.
`type`: 1
`if row names are required;`: 2
`if column names are required.`: 3
`if set names are required.`: names
`A buffer into which the names will be returned as a sequence of null-terminated strings. The buffer should be of length`: names_len bytes. May be NULL if
`names_len is`: 0.
`names_len`: The maximum number of bytes that may be written to the buffer
`names.`: names_len_reqd
`A pointer to a variable into which will be written the number of bytes required to contain the names in the specified range. May be NULL if not required.`: first
`First row, column or set in the range.`: last

*Example*

The following example retrieves and outputs the row and column names for the current problem.

*Related*

XPRSaddnames.
"""
function getnamelist(prob::XpressProblem, _itype, _sbuff, names_len, names_len_reqd, first::Integer, last::Integer)
    @checked Lib.XPRSgetnamelist(prob, _itype, _sbuff, names_len, names_len_reqd, first, last)
end

"""

    getnamelistobject(prob::XpressProblem, _itype, r_nl)

*Purpose*

Returns the
XPRSnamelist object for the rows, columns or sets of a problem. The names stored in this object can be queried using the
XPRS_nml_ functions.

*Synopsis*

int XPRS_CC XPRSgetnamelistobject(XPRSprob prob, int itype, XPRSnamelist *r_nml);

*Arguments*

`prob`: The current problem.
`itype`: 1
`if the row name list is required;`: 2
`if the column name list is required;`: 3
`if the set name list is required.`: r_nml

*Example*



*Related*

None.
"""
function getnamelistobject(prob::XpressProblem, _itype, r_nl)
    @checked Lib.XPRSgetnamelistobject(prob, _itype, r_nl)
end

function logfilehandler(obj, vUserContext, vSystemThreadId, sMsg, iMsgType, iMsgCode)
    @checked Lib.XPRSlogfilehandler(obj, vUserContext, vSystemThreadId, sMsg, iMsgType, iMsgCode)
end

"""

    getobjecttypename(obj, sObjectName)

*Purpose*

Function to access the type name of an object referenced using the generic Optimizer object pointer
XPRSobject.

*Synopsis*

int XPRS_CC XPRSgetobjecttypename(XPRSobject object, const char **sObjectName);

*Arguments*

`object`: The object for which the type name will be retrieved.
`sObjectName`: Pointer to a char pointer returning a reference to the null terminated string containing the object's type name. For example, if the object is of type
`XPRSprob then the returned pointer points to the string "`: XPRSprob".

*Example*



*Related*

XPRS_ge_addcbmsghandler.
"""
function getobjecttypename(obj, sObjectName)
    @checked Lib.XPRSgetobjecttypename(obj, sObjectName)
end

"""

    strongbranchcb(prob::XpressProblem, nbnds, _mindex, _sboundtype, _dbnd, itrlimit, _dsbobjval, _msbstatus, sbsolvecb, vContext)

*Purpose*

Performs strong branching iterations on all specified bound changes. For each candidate bound change,
XPRSstrongbranchcb performs dual simplex iterations starting from the current optimal solution of the base LP, and returns both the status and objective value reached after these iterations.

*Synopsis*

int XPRS_CC XPRSstrongbranchcb(XPRSprob prob, const int nbnds, const int mbndind[], const char cbndtype[], const double dbndval[], const int itrlimit, double dsbobjval[], int msbstatus[], int (XPRS_CC *sbsolvecb)(XPRSprob prob, void* vContext, int ibnd), void* vContext);

*Arguments*

`prob`: The current problem.
`nbnds`: Number of bound changes to try.
`mbndind`: Integer array of size
`nbnds containing the indices of the columns on which the bounds will change.`: cbndtype
`Character array of length`: nbnds indicating the type of bound to change:
`U`: indicates change the upper bound;
`L`: indicates change the lower bound;
`B`: indicates change both bounds, i.e. fix the column.
`dbndval`: Double array of length
`nbnds giving the new bound values.`: itrlimit
`Maximum number of LP iterations to perform for each bound change.`: dsobjval
`Objective value of each LP after performing the strong branching iterations.`: msbstatus
`Status of each LP after performing the strong branching iterations, as detailed for the`: LPSTATUS attribute.
`sbsolvecb`: Function to be called after each strong branch has been reoptimized.
`vContext`: User context to be provided for
`sbsolvecb.`: ibnd
`The index of bound for which`: sbsolvecb is called.

*Example*



*Related*


"""
function strongbranchcb(prob::XpressProblem, nbnds::Int, _mindex::Vector{Float64}, _sboundtype, _dbnd, itrlimit, _dsbobjval, _msbstatus, sbsolvecb, vContext)
    @checked Lib.XPRSstrongbranchcb(prob, nbnds, _mindex, _sboundtype, _dbnd, itrlimit, _dsbobjval, _msbstatus, sbsolvecb, vContext)
end

function setcblplog(prob::XpressProblem, f_lplog, p)
    @checked Lib.XPRSsetcblplog(prob, f_lplog, p)
end

function getcblplog(prob::XpressProblem, f_lplog, p)
    @checked Lib.XPRSgetcblplog(prob, f_lplog, p)
end

"""

    addcblplog(prob::XpressProblem, f_lplog, p, priority)

*Purpose*

Declares a
simplex log
callback function which is called after every
LPLOG
iterations of the simplex algorithm. This callback function will be called in addition to any callbacks already added by XPRSaddcblplog.

*Synopsis*

int XPRS_CC XPRSaddcblplog(XPRSprob prob, int (XPRS_CC *f_lplog)(XPRSprob my_prob, void* my_object), void* object, int priority);

*Arguments*

`prob`: The current problem.
`f_lplog`: The callback function which takes two arguments,
`my_prob and`: my_object, and has an integer return value. This function is called every
`LPLOG simplex iterations including iteration`: 0 and the final iteration.
`my_prob`: The problem passed to the callback function,
`f_lplog.`: my_object
`The user-defined object passed as`: object when setting up the callback with
`XPRSaddcblplog.`: object
`A user-defined object to be passed to the callback function,`: f_lplog.
`priority`: An integer that determines the order in which multiple lplog callbacks will be invoked. The callback added with a higher priority will be called before a callback with a lower priority. Set to 0 if not required.

*Example*

The following code sets a callback function,
lpLog, to be called every
10 iterations of the optimization:

*Related*

XPRSremovecblplog,
XPRSaddcbbarlog,
XPRSaddcbgloballog,
XPRSaddcbmessage.
"""
function addcblplog(prob::XpressProblem, f_lplog, p, priority)
    @checked Lib.XPRSaddcblplog(prob, f_lplog, p, priority)
end

"""

    removecblplog(prob::XpressProblem, f_lplog, p)

*Purpose*

Removes a
simplex log
callback function previously added by
XPRSaddcblplog. The specified callback function will no longer be called after it has been removed.

*Synopsis*

int XPRS_CC XPRSremovecblplog(XPRSprob prob, int (XPRS_CC *f_lplog)(XPRSprob prob, void* object), void* object);

*Arguments*

`prob`: The current problem.
`f_lplog`: The callback function to remove. If NULL then all lplog callback functions added with the given user-defined object value will be removed.
`object`: The object value that the callback was added with. If NULL, then the object value will not be checked and all lplog callbacks with the function pointer

*Example*

The following code sets and removes a callback function:

*Related*

XPRSaddcblplog
"""
function removecblplog(prob::XpressProblem, f_lplog, p)
    @checked Lib.XPRSremovecblplog(prob, f_lplog, p)
end

function setcbgloballog(prob::XpressProblem, f_globallog, p)
    @checked Lib.XPRSsetcbgloballog(prob, f_globallog, p)
end

function getcbgloballog(prob::XpressProblem, f_globallog, p)
    @checked Lib.XPRSgetcbgloballog(prob, f_globallog, p)
end

"""

    addcbgloballog(prob::XpressProblem, f_globallog, p, priority)

*Purpose*

Declares a global log
callback function, called each time the
global log is printed. This callback function will be called in addition to any callbacks already added by XPRSaddcbgloballog.

*Synopsis*

int XPRS_CC XPRSaddcbgloballog(XPRSprob prob, int (XPRS_CC *f_globallog)(XPRSprob my_prob, void *my_object), void *object, int priority);

*Arguments*

`prob`: The current problem.
`f_globallog`: The callback function which takes two arguments,
`my_prob and`: my_object, and has an integer return value. This function is called whenever the global log is printed as determined by the
`MIPLOG control.`: my_prob
`The problem passed to the callback function,`: f_globallog.
`my_object`: The user-defined object passed as
`object when setting up the callback with`: XPRSaddcbgloballog.
`object`: A user-defined object to be passed to the callback function,
`f_globallog.`: priority

*Example*

The following example prints at each node of the global search the node number and its depth:

*Related*

XPRSremovecbgloballog,
XPRSaddcbbarlog,
XPRSaddcblplog,
XPRSaddcbmessage.
"""
function addcbgloballog(prob::XpressProblem, f_globallog, p, priority)
    @checked Lib.XPRSaddcbgloballog(prob, f_globallog, p, priority)
end

"""

    removecbgloballog(prob::XpressProblem, f_globallog, p)

*Purpose*

Removes a global log
callback function previously added by
XPRSaddcbgloballog. The specified callback function will no longer be called after it has been removed.

*Synopsis*

int XPRS_CC XPRSremovecbgloballog(XPRSprob prob, int (XPRS_CC *f_globallog)(XPRSprob prob, void* vContext), void* object);

*Arguments*

`prob`: The current problem.
`f_globallog`: The callback function to remove. If NULL then all global log callback functions added with the given user-defined object value will be removed.
`object`: The object value that the callback was added with. If NULL, then the object value will not be checked and all global log callbacks with the function pointer

*Example*

The following code sets and removes a callback function:

*Related*

XPRSaddcbgloballog
"""
function removecbgloballog(prob::XpressProblem, f_globallog, p)
    @checked Lib.XPRSremovecbgloballog(prob, f_globallog, p)
end

function setcbcutlog(prob::XpressProblem, f_cutlog, p)
    @checked Lib.XPRSsetcbcutlog(prob, f_cutlog, p)
end

function getcbcutlog(prob::XpressProblem, f_cutlog, p)
    @checked Lib.XPRSgetcbcutlog(prob, f_cutlog, p)
end

"""

    addcbcutlog(prob::XpressProblem, f_cutlog, p, priority)

*Purpose*

Declares a cut log callback function, called each time the cut log is printed. This callback function will be called in addition to any callbacks already added by XPRSaddcbcutlog.

*Synopsis*

int XPRS_CC XPRSaddcbcutlog(XPRSprob prob, int (XPRS_CC *f_cutlog)(XPRSprob my_prob, void *my_object), void *object, int priority);

*Arguments*

`prob`: The current problem.
`f_cutlog`: The callback function which takes two arguments,
`my_prob and`: my_object, and has an integer return value.
`my_prob`: The problem passed to the callback function,
`f_cutlog.`: my_object
`The user-defined object passed as`: object when setting up the callback with
`XPRSaddcbcutlog.`: object
`A user-defined object to be passed to the callback function,`: f_cutlog.
`priority`: An integer that determines the order in which multiple cut log callbacks will be invoked. The callback added with a higher priority will be called before a callback with a lower priority. Set to 0 if not required.

*Example*



*Related*

XPRSremovecbcutlog,
XPRSaddcbcutmgr.
"""
function addcbcutlog(prob::XpressProblem, f_cutlog, p, priority)
    @checked Lib.XPRSaddcbcutlog(prob, f_cutlog, p, priority)
end

"""

    removecbcutlog(prob::XpressProblem, f_cutlog, p)

*Purpose*

Removes a cut log callback function previously added by
XPRSaddcbcutlog. The specified callback function will no longer be called after it has been removed.

*Synopsis*

int XPRS_CC XPRSremovecbcutlog(XPRSprob prob, int (XPRS_CC *f_cutlog)(XPRSprob prob, void* object), void* object);

*Arguments*

`prob`: The current problem.
`f_cutlog`: The callback function to remove. If NULL then all cut log callback functions added with the given user-defined object value will be removed.
`object`: The object value that the callback was added with. If NULL, then the object value will not be checked and all cut log callbacks with the function pointer

*Example*



*Related*

XPRSaddcbcutlog
"""
function removecbcutlog(prob::XpressProblem, f_cutlog, p)
    @checked Lib.XPRSremovecbcutlog(prob, f_cutlog, p)
end

function setcbbarlog(prob::XpressProblem, f_barlog, p)
    @checked Lib.XPRSsetcbbarlog(prob, f_barlog, p)
end

function getcbbarlog(prob::XpressProblem, f_barlog, p)
    @checked Lib.XPRSgetcbbarlog(prob, f_barlog, p)
end

"""

    addcbbarlog(prob::XpressProblem, f_barlog, p, priority)

*Purpose*

Declares a
barrier log
callback function, called at each iteration during the interior point algorithm. This callback function will be called in addition to any barrier log callbacks already added by XPRSaddcbbarlog.

*Synopsis*

int XPRS_CC XPRSaddcbbarlog (XPRSprob prob, int (XPRS_CC *f_barlog)(XPRSprob my_prob, void *my_object), void *object, int priority);

*Arguments*

`prob`: The current problem.
`f_barlog`: The callback function itself. This takes two arguments,
`my_prob and`: my_object, and has an integer return value. If the value returned by
`f_barlog is nonzero, the solution process will be interrupted. This function is called at every barrier iteration.`: my_prob
`The problem passed to the callback function,`: f_barlog.
`my_object`: The user-defined object passed as
`object when setting up the callback with`: XPRSaddcbbarlog.
`object`: A user-defined object to be passed to the callback function,
`f_barlog.`: priority

*Example*

This simple example prints a line to the screen for each iteration of the algorithm.

*Related*

XPRSremovecbbarlog,
XPRSaddcbgloballog,
XPRSaddcblplog,
XPRSaddcbmessage.
"""
function addcbbarlog(prob::XpressProblem, f_barlog, p, priority)
    @checked Lib.XPRSaddcbbarlog(prob, f_barlog, p, priority)
end

"""

    removecbbarlog(prob::XpressProblem, f_barlog, p)

*Purpose*

Removes a Newton barrier log callback function previously added by
XPRSaddcbbarlog. The specified callback function will no longer be called after it has been removed.

*Synopsis*

int XPRS_CC XPRSremovecbbarlog(XPRSprob prob, int (XPRS_CC *f_barlog)(XPRSprob prob, void* object), void* object);

*Arguments*

`prob`: The current problem.
`f_barlog`: The callback function to remove. If NULL then all barrier log callback functions added with the given user-defined object value will be removed.
`object`: The object value that the callback was added with. If NULL, then the object value will not be checked and all barrier log callbacks with the function pointer

*Example*



*Related*

XPRSaddcbbarlog.
"""
function removecbbarlog(prob::XpressProblem, f_barlog, p)
    @checked Lib.XPRSremovecbbarlog(prob, f_barlog, p)
end

function setcbcutmgr(prob::XpressProblem, f_cutmgr, p)
    @checked Lib.XPRSsetcbcutmgr(prob, f_cutmgr, p)
end

function getcbcutmgr(prob::XpressProblem, f_cutmgr, p)
    @checked Lib.XPRSgetcbcutmgr(prob, f_cutmgr, p)
end

"""

    addcbcutmgr(prob::XpressProblem, f_cutmgr, p, priority)

*Purpose*

This function is deprecated and may be removed in future releases. Please use XPRSaddcboptnode instead. Declares a user-defined
cut manager routine, called at each
node of the branch and bound search. This callback function will be called in addition to any callbacks already added by XPRSaddcbcutmgr.

*Synopsis*

int XPRS_CC XPRSaddcbcutmgr(XPRSprob prob, int (XPRS_CC *f_cutmgr)(XPRSprob my_prob, void *my_object), void *object, int priority);

*Arguments*

`prob`: The current problem
`f_cutmgr`: The callback function which takes two arguments,
`my_prob and`: my_object, and has an integer return value. This function is called at each node in the Branch and Bound search.
`my_prob`: The problem passed to the callback function,
`f_cutmgr.`: my_object
`The user-defined object passed as`: object when setting up the callback with
`XPRSaddcbcutmgr.`: object
`A user-defined object to be passed to the callback function,`: f_cutmgr.
`priority`: An integer that determines the order in which multiple global log callbacks will be invoked. The callback added with a higher priority will be called before a callback with a lower priority. Set to 0 if not required.

*Example*



*Related*

XPRSremovecbcutmgr,
XPRSaddcbcutlog,
CALLBACKCOUNT_CUTMGR.
"""
function addcbcutmgr(prob::XpressProblem, f_cutmgr, p, priority)
    @checked Lib.XPRSaddcbcutmgr(prob, f_cutmgr, p, priority)
end

"""

    removecbcutmgr(prob::XpressProblem, f_cutmgr, p)

*Purpose*

Removes a cut manager callback function previously added by
XPRSaddcbcutmgr. The specified callback function will no longer be called after it has been removed.

*Synopsis*

int XPRS_CC XPRSremovecbcutmgr(XPRSprob prob, int (XPRS_CC *f_cutmgr)(XPRSprob prob, void* object), void* object);

*Arguments*

`prob`: The current problem.
`f_cutmgr`: The callback function to remove. If NULL then all cut manager callback functions added with the given user-defined object value will be removed.
`object`: The object value that the callback was added with. If NULL, then the object value will not be checked and all cut manager callbacks with the function pointer

*Example*



*Related*

XPRSaddcbcutmgr
"""
function removecbcutmgr(prob::XpressProblem, f_cutmgr, p)
    @checked Lib.XPRSremovecbcutmgr(prob, f_cutmgr, p)
end

function setcbchgnode(prob::XpressProblem, f_chgnode, p)
    @checked Lib.XPRSsetcbchgnode(prob, f_chgnode, p)
end

function getcbchgnode(prob::XpressProblem, f_chgnode, p)
    @checked Lib.XPRSgetcbchgnode(prob, f_chgnode, p)
end

"""

    addcbchgnode(prob::XpressProblem, f_chgnode, p, priority)

*Purpose*

This function is deprecated and may be removed in future releases. Declares a
node selection
callback function. This is called every time the code backtracks to select a new node during the MIP
search. This callback function will be called in addition to any callbacks already added by XPRSaddcbchgnode.

*Synopsis*

int XPRS_CC XPRSaddcbchgnode(XPRSprob prob, void (XPRS_CC *f_chgnode)(XPRSprob my_prob, void *my_object, int *nodnum), void *object, int priority);

*Arguments*

`prob`: The current problem.
`f_chgnode`: The callback function which takes three arguments,
`my_prob,`: my_object and
`nodnum, and has no return value. This function is called every time a new node is selected.`: my_prob
`The problem passed to the callback function,`: f_chgnode.
`my_object`: The user-defined object passed as
`object when setting up the callback with`: XPRSaddcbchgnode.
`nodnum`: A pointer to the number of the node,
`nodnum, selected by the Optimizer. By changing the value pointed to by this argument, the selected node may be changed with this function.`: object
`A user-defined object to be passed to the callback function,`: f_chgnode.
`priority`: An integer that determines the order in which multiple node selection callbacks will be invoked. The callback added with a higher priority will be called before a callback with a lower priority. Set to 0 if not required.

*Example*

The following prints out the node number every time a new node is selected during the global search:

*Related*

XPRSremovecbchgnode,
XPRSaddcboptnode,
XPRSaddcbinfnode,
XPRSaddcbintsol,
XPRSaddcbnodecutoff,
XPRSaddcbchgbranch,
XPRSaddcbprenode.
"""
function addcbchgnode(prob::XpressProblem, f_chgnode, p, priority)
    @checked Lib.XPRSaddcbchgnode(prob, f_chgnode, p, priority)
end

"""

    removecbchgnode(prob::XpressProblem, f_chgnode, p)

*Purpose*

Removes a node selection callback function previously added by
XPRSaddcbchgnode. The specified callback function will no longer be called after it has been removed.

*Synopsis*

int XPRS_CC XPRSremovecbchgnode(XPRSprob prob, void (XPRS_CC *f_chgnode)(XPRSprob prob, void* object, int* nodnum), void* object);

*Arguments*

`prob`: The current problem.
`f_chgnode`: The callback function to remove. If NULL then all node selection callback functions added with the given user-defined object value will be removed.
`object`: The object value that the callback was added with. If NULL, then the object value will not be checked and all node selection callbacks with the function pointer

*Example*



*Related*

XPRSaddcbchgnode
"""
function removecbchgnode(prob::XpressProblem, f_chgnode, p)
    @checked Lib.XPRSremovecbchgnode(prob, f_chgnode, p)
end

function setcboptnode(prob::XpressProblem, f_optnode, p)
    @checked Lib.XPRSsetcboptnode(prob, f_optnode, p)
end

function getcboptnode(prob::XpressProblem, f_optnode, p)
    @checked Lib.XPRSgetcboptnode(prob, f_optnode, p)
end

"""

    addcboptnode(prob::XpressProblem, f_optnode, p, priority)

*Purpose*

Declares an optimal
node
callback function, called during the branch and bound search, after the LP relaxation has been solved for the current node, and after any internal cuts and heuristics have been applied, but before the Optimizer checks if the current node should be branched. This callback function will be called in addition to any callbacks already added by XPRSaddcboptnode.

*Synopsis*

int XPRS_CC XPRSaddcboptnode(XPRSprob prob, void (XPRS_CC *f_optnode)(XPRSprob my_prob, void *my_object, int *feas), void *object, int priority);

*Arguments*

`prob`: The current problem.
`f_optnode`: The callback function which takes three arguments,
`my_prob,`: my_object and
`feas, and has no return value.`: my_prob
`The problem passed to the callback function,`: f_optnode.
`my_object`: The user-defined object passed as
`object when setting up the callback with`: XPRSaddcboptnode.
`feas`: The feasibility status. If set to a nonzero value by the user, the current node will be declared infeasible.
`object`: A user-defined object to be passed to the callback function,
`f_optnode.`: priority

*Example*

The following prints the optimal objective value of the node LP relaxations:

*Related*

XPRSremovecboptnode,
XPRSaddcbinfnode,
XPRSaddcbintsol,
XPRSaddcbnodecutoff,
CALLBACKCOUNT_OPTNODE.
"""
function addcboptnode(prob::XpressProblem, f_optnode, p, priority)
    @checked Lib.XPRSaddcboptnode(prob, f_optnode, p, priority)
end

"""

    removecboptnode(prob::XpressProblem, f_optnode, p)

*Purpose*

Removes a node-optimal callback function previously added by
XPRSaddcboptnode. The specified callback function will no longer be called after it has been removed.

*Synopsis*

int XPRS_CC XPRSremovecboptnode(XPRSprob prob, void (XPRS_CC *f_optnode)(XPRSprob my_prob, void *my_object, int *feas), void* object);

*Arguments*

`prob`: The current problem.
`f_optnode`: The callback function to remove. If NULL then all node-optimal callback functions added with the given user-defined object value will be removed.
`object`: The object value that the callback was added with. If NULL, then the object value will not be checked and all node-optimal callbacks with the function pointer

*Example*



*Related*

XPRSaddcboptnode
"""
function removecboptnode(prob::XpressProblem, f_optnode, p)
    @checked Lib.XPRSremovecboptnode(prob, f_optnode, p)
end

function setcbprenode(prob::XpressProblem, f_prenode, p)
    @checked Lib.XPRSsetcbprenode(prob, f_prenode, p)
end

function getcbprenode(prob::XpressProblem, f_prenode, p)
    @checked Lib.XPRSgetcbprenode(prob, f_prenode, p)
end

"""

    addcbprenode(prob::XpressProblem, f_prenode, p, priority)

*Purpose*

Declares a preprocess node
callback function, called before the
LP relaxation of a node has been optimized, so the solution at the node will not be available. This callback function will be called in addition to any callbacks already added by XPRSaddcbprenode.

*Synopsis*

int XPRS_CC XPRSaddcbprenode(XPRSprob prob, void (XPRS_CC *f_prenode)(XPRSprob my_prob, void *my_object, int *nodinfeas), void *object, int priority);

*Arguments*

`prob`: The current problem.
`f_prenode`: The callback function, which takes three arguments,
`my_prob,`: my_object and
`nodinfeas, and has no return value. This function is called before a node is reoptimized and the node may be made infeasible by setting`: *nodinfeas to
`1.`: my_prob
`The problem passed to the callback function,`: f_prenode.
`my_object`: The user-defined object passed as
`object when setting up the callback with`: XPRSaddcbprenode.
`nodinfeas`: The feasibility status. If set to a nonzero value by the user, the current node will be declared infeasible by the Optimizer.
`object`: A user-defined object to be passed to the callback function,
`f_prenode.`: priority

*Example*

The following example notifies the user before each node is processed:

*Related*

XPRSremovecbprenode,
XPRSaddcbchgnode,
XPRSaddcbinfnode,
XPRSaddcbintsol,
XPRSaddcbnodecutoff,
XPRSaddcboptnode.
"""
function addcbprenode(prob::XpressProblem, f_prenode, p, priority)
    @checked Lib.XPRSaddcbprenode(prob, f_prenode, p, priority)
end

"""

    removecbprenode(prob::XpressProblem, f_prenode, p)

*Purpose*

Removes a preprocess node callback function previously added by
XPRSaddcbprenode. The specified callback function will no longer be called after it has been removed.

*Synopsis*

int XPRS_CC XPRSremovecbprenode(XPRSprob prob, void (XPRS_CC *f_prenode)(XPRSprob prob, void* my_object, int* nodinfeas), void* object);

*Arguments*

`prob`: The current problem.
`f_prenode`: The callback function to remove. If NULL then all preprocess node callback functions added with the given user-defined object value will be removed.
`object`: The object value that the callback was added with. If NULL, then the object value will not be checked and all preprocess node callbacks with the function pointer

*Example*



*Related*

XPRSaddcbprenode
"""
function removecbprenode(prob::XpressProblem, f_prenode, p)
    @checked Lib.XPRSremovecbprenode(prob, f_prenode, p)
end

function setcbinfnode(prob::XpressProblem, f_infnode, p)
    @checked Lib.XPRSsetcbinfnode(prob, f_infnode, p)
end

function getcbinfnode(prob::XpressProblem, f_infnode, p)
    @checked Lib.XPRSgetcbinfnode(prob, f_infnode, p)
end

"""

    addcbinfnode(prob::XpressProblem, f_infnode, p, priority)

*Purpose*

Declares a user infeasible
node callback function, called after the current node has been found to be infeasible during the Branch and Bound
search. This callback function will be called in addition to any callbacks already added by XPRSaddcbinfnode.

*Synopsis*

int XPRS_CC XPRSaddcbinfnode(XPRSprob prob, void (XPRS_CC *f_infnode)(XPRSprob my_prob, void *my_object), void *object, int priority);

*Arguments*

`prob`: The current problem
`f_infnode`: The callback function which takes two arguments,
`my_prob and`: my_object, and has no return value. This function is called after the current node has been found to be infeasible.
`my_prob`: The problem passed to the callback function,
`f_infnode.`: my_object
`The user-defined object passed as`: object when setting up the callback with
`XPRSaddcbinfnode.`: object
`A user-defined object to be passed to the callback function,`: f_infnode.
`priority`: An integer that determines the order in which multiple user infeasible node callbacks will be invoked. The callback added with a higher priority will be called before a callback with a lower priority. Set to 0 if not required.

*Example*

The following notifies the user whenever an infeasible node is found during the global search:

*Related*

XPRSremovecbinfnode,
XPRSaddcboptnode,
XPRSaddcbintsol,
XPRSaddcbnodecutoff.
"""
function addcbinfnode(prob::XpressProblem, f_infnode, p, priority)
    @checked Lib.XPRSaddcbinfnode(prob, f_infnode, p, priority)
end

"""

    removecbinfnode(prob::XpressProblem, f_infnode, p)

*Purpose*

Removes a user infeasible node callback function previously added by
XPRSaddcbinfnode. The specified callback function will no longer be called after it has been removed.

*Synopsis*

int XPRS_CC XPRSremovecbinfnode(XPRSprob prob, void (XPRS_CC *f_infnode)(XPRSprob prob, void* object), void* object);

*Arguments*

`prob`: The current problem.
`f_infnode`: The callback function to remove. If NULL then all user infeasible node callback functions added with the given user-defined object value will be removed.
`object`: The object value that the callback was added with. If NULL, then the object value will not be checked and all user infeasible node callbacks with the function pointer

*Example*



*Related*

XPRSaddcbinfnode
"""
function removecbinfnode(prob::XpressProblem, f_infnode, p)
    @checked Lib.XPRSremovecbinfnode(prob, f_infnode, p)
end

function setcbnodecutoff(prob::XpressProblem, f_nodecutoff, p)
    @checked Lib.XPRSsetcbnodecutoff(prob, f_nodecutoff, p)
end

function getcbnodecutoff(prob::XpressProblem, f_nodecutoff, p)
    @checked Lib.XPRSgetcbnodecutoff(prob, f_nodecutoff, p)
end

"""

    addcbnodecutoff(prob::XpressProblem, f_nodecutoff, p, priority)

*Purpose*

Declares a user node
cutoff
callback function, called every time a node is cut off as a result of an improved
integer solution being found during the branch and bound search. This callback function will be called in addition to any callbacks already added by XPRSaddcbnodecutoff.

*Synopsis*

int XPRS_CC XPRSaddcbnodecutoff(XPRSprob prob, void (XPRS_CC *f_nodecutoff)(XPRSprob my_prob, void *my_object, int node), void *object, int priority);

*Arguments*

`prob`: The current problem.
`f_nodecutoff`: The callback function, which takes three arguments,
`my_prob,`: my_object and
`node, and has no return value. This function is called every time a node is cut off as the result of an improved integer solution being found.`: my_prob
`The problem passed to the callback function,`: f_nodecutoff.
`my_object`: The user-defined object passed as
`object when setting up the callback with`: XPRSaddcbnodecutoff.
`node`: The number of the node that is cut off.
`object`: A user-defined object to be passed to the callback function,
`f_nodecutoff.`: priority

*Example*

The following notifies the user whenever a node is cutoff during the global search:

*Related*

XPRSremovecbnodecutoff,
XPRSaddcboptnode,
XPRSaddcbinfnode,
XPRSaddcbintsol.
"""
function addcbnodecutoff(prob::XpressProblem, f_nodecutoff, p, priority)
    @checked Lib.XPRSaddcbnodecutoff(prob, f_nodecutoff, p, priority)
end

"""

    removecbnodecutoff(prob::XpressProblem, f_nodecutoff, p)

*Purpose*

Removes a node-cutoff callback function previously added by
XPRSaddcbnodecutoff. The specified callback function will no longer be called after it has been removed.

*Synopsis*

int XPRS_CC XPRSremovecbnodecutoff(XPRSprob prob, void (XPRS_CC *f_nodecutoff)(XPRSprob my_prob, void *my_object, int nodnum), void* object);

*Arguments*

`prob`: The current problem.
`f_nodecutoff`: The callback function to remove. If NULL then all node-cutoff callback functions added with the given user-defined object value will be removed.
`object`: The object value that the callback was added with. If NULL, then the object value will not be checked and all node-cutoff callbacks with the function pointer

*Example*



*Related*

XPRSaddcbnodecutoff
"""
function removecbnodecutoff(prob::XpressProblem, f_nodecutoff, p)
    @checked Lib.XPRSremovecbnodecutoff(prob, f_nodecutoff, p)
end

function setcbintsol(prob::XpressProblem, f_intsol, p)
    @checked Lib.XPRSsetcbintsol(prob, f_intsol, p)
end

function getcbintsol(prob::XpressProblem, f_intsol, p)
    @checked Lib.XPRSgetcbintsol(prob, f_intsol, p)
end

"""

    addcbintsol(prob::XpressProblem, f_intsol, p, priority)

*Purpose*

Declares a user integer solution
callback function, called every time an integer solution is found by heuristics or during the Branch and Bound search. This callback function will be called in addition to any callbacks already added by XPRSaddcbintsol.

*Synopsis*

int XPRS_CC XPRSaddcbintsol(XPRSprob prob, void (XPRS_CC *f_intsol)(XPRSprob my_prob, void *my_object), void *object, int priority);

*Arguments*

`prob`: The current problem.
`f_intsol`: The callback function which takes two arguments,
`my_prob and`: my_object, and has no return value. This function is called if the current node is found to have an integer feasible solution, i.e. every time an integer feasible solution is found.
`my_prob`: The problem passed to the callback function,
`f_intsol.`: my_object
`The user-defined object passed as`: object when setting up the callback with
`XPRSaddcbintsol.`: object
`A user-defined object to be passed to the callback function,`: f_intsol.
`priority`: An integer that determines the order in which multiple integer solution callbacks will be invoked. The callback added with a higher priority will be called before a callback with a lower priority. Set to 0 if not required.

*Example*

The following example prints integer solutions as they are discovered in the global search:

*Related*

XPRSremovecbintsol,
XPRSaddcbpreintsol.
"""
function addcbintsol(prob::XpressProblem, f_intsol, p, priority)
    @checked Lib.XPRSaddcbintsol(prob, f_intsol, p, priority)
end

"""

    removecbintsol(prob::XpressProblem, f_intsol, p)

*Purpose*

Removes an integer solution callback function previously added by
XPRSaddcbintsol. The specified callback function will no longer be called after it has been removed.

*Synopsis*

int XPRS_CC XPRSremovecbintsol(XPRSprob prob, void (XPRS_CC *f_intsol)(XPRSprob prob, void* my_object), void* object);

*Arguments*

`prob`: The current problem.
`f_intsol`: The callback function to remove. If NULL then all integer solution callback functions added with the given user-defined object value will be removed.
`object`: The object value that the callback was added with. If NULL, then the object value will not be checked and all integer solution callbacks with the function pointer

*Example*



*Related*

XPRSaddcbintsol
"""
function removecbintsol(prob::XpressProblem, f_intsol, p)
    @checked Lib.XPRSremovecbintsol(prob, f_intsol, p)
end

function setcbpreintsol(prob::XpressProblem, f_preintsol, p)
    @checked Lib.XPRSsetcbpreintsol(prob, f_preintsol, p)
end

function getcbpreintsol(prob::XpressProblem, f_preintsol, p)
    @checked Lib.XPRSgetcbpreintsol(prob, f_preintsol, p)
end

"""

    addcbpreintsol(prob::XpressProblem, f_preintsol, p, priority)

*Purpose*

Declares a user integer solution callback function, called when an integer solution is found by heuristics or during the branch and bound search, but before it is accepted by the Optimizer. This callback function will be called in addition to any integer solution callbacks already added by XPRSaddcbpreintsol.

*Synopsis*

int XPRS_CC XPRSaddcbpreintsol(XPRSprob prob, void (XPRS_CC *f_preintsol)(XPRSprob my_prob, void *my_object, int soltype, int *ifreject, double *cutoff), void *object, int priority);

*Arguments*

`prob`: The current problem.
`f_preintsol`: The callback function which takes five arguments,
`my_prob,`: my_object,
`soltype,`: ifreject and
`cutoff, and has no return value. This function is called when an integer solution is found, but before the solution is accepted by the Optimizer, allowing the user to reject the solution.`: my_prob
`The problem passed to the callback function,`: f_preintsol.
`my_object`: The user-defined object passed as object when setting up the callback with
`XPRSaddcbpreintsol.`: soltype
`The type of MIP solution that has been found: Set to 1 if the solution was found using a heuristic. Otherwise, it will be the global feasible solution to the current node of the global search.`: 0
`The continuous relaxation solution to the current node of the global search, which has been found to be global feasible.`: 1
`A MIP solution found by a heuristic.`: 2
`A MIP solution provided by the user.`: 3
`A solution resulting from refinement of primal or dual violations of a previous MIP solution.`: ifreject
`Set this to 1 if the solution should be rejected.`: cutoff
`The new`: cutoff value that the Optimizer will use if the solution is accepted. If the user changes
`cutoff, the new value will be used instead. The`: cutoff value will not be updated if the solution is rejected.
`object`: A user-defined object to be passed to the callback function,
`f_preintsol.`: priority

*Example*



*Related*

XPRSremovecbpreintsol,
XPRSaddcbintsol.
"""
function addcbpreintsol(prob::XpressProblem, f_preintsol, p, priority)
    @checked Lib.XPRSaddcbpreintsol(prob, f_preintsol, p, priority)
end

"""

    removecbpreintsol(prob::XpressProblem, f_preintsol, p)

*Purpose*

Removes a pre-integer solution callback function previously added by
XPRSaddcbpreintsol. The specified callback function will no longer be called after it has been removed.

*Synopsis*

int XPRS_CC XPRSremovecbpreintsol(XPRSprob prob, void (XPRS_CC *f_preintsol)(XPRSprob my_prob, void *my_object, int soltype, int *ifreject, double *cutoff), void* object);

*Arguments*

`prob`: The current problem.
`f_preintsol`: The callback function to remove. If NULL then all user infeasible node callback functions added with the given user-defined object value will be removed.
`object`: The object value that the callback was added with. If NULL, then the object value will not be checked and all user infeasible node callbacks with the function pointer

*Example*



*Related*

XPRSaddcbpreintsol
"""
function removecbpreintsol(prob::XpressProblem, f_preintsol, p)
    @checked Lib.XPRSremovecbpreintsol(prob, f_preintsol, p)
end

function setcbchgbranch(prob::XpressProblem, f_chgbranch, p)
    @checked Lib.XPRSsetcbchgbranch(prob, f_chgbranch, p)
end

function getcbchgbranch(prob::XpressProblem, f_chgbranch, p)
    @checked Lib.XPRSgetcbchgbranch(prob, f_chgbranch, p)
end

"""

    addcbchgbranch(prob::XpressProblem, f_chgbranch, p, priority)

*Purpose*

This function is deprecated and may be removed in future releases. Please use XPRSaddcbchgbranchobject instead.  Declares a branching variable
callback function, called every time a new
branching variable is set or selected during the branch and bound
search. This callback function will be called in addition to any change branch callbacks already added by XPRSaddcbchgbranch.

*Synopsis*

int XPRS_CC XPRSaddcbchgbranch(XPRSprob prob, void (XPRS_CC *f_chgbranch)(XPRSprob my_prob, void *my_object, int *entity, int *up, double *estdeg), void *object, int priority);

*Arguments*

`prob`: The current problem.
`f_chgbranch`: The callback function, which takes five arguments,
`my_prob,`: my_object,
`entity,`: up and
`estdeg, and has no return value. This function is called every time a new branching variable or set is selected.`: my_prob
`The problem passed to the callback function,`: f_chgbranch.
`my_object`: The user-defined object passed as
`object when setting up the callback with`: XPRSaddcbchgbranch.
`entity`: A pointer to the variable or set on which to branch. Ordinary global variables are identified by their column index, i.e.
`0,`: 1,...(
`COLS`: - 1) and by their set index, i.e.
`0,`: 1,...,(
`SETS`: - 1).
`up`: If
`entity is a variable, this is`: 1 if the upward branch is to be made first, or
`0 otherwise. If`: entity is a set, this is
`3 if the upward branch is to be made first, or`: 2 otherwise.
`estdeg`: This value is obsolete. It will be set to zero and any returned value is ignored.
`object`: A user-defined object to be passed to the callback function,
`f_chgbranch.`: priority

*Example*



*Related*

XPRSremovecbchgbranch,
XPRSaddcbchgnode,
XPRSaddcboptnode,
XPRSaddcbinfnode,
XPRSaddcbintsol,
XPRSaddcbnodecutoff,
XPRSaddcbprenode.
"""
function addcbchgbranch(prob::XpressProblem, f_chgbranch, p, priority)
    @checked Lib.XPRSaddcbchgbranch(prob, f_chgbranch, p, priority)
end

"""

    removecbchgbranch(prob::XpressProblem, f_chgbranch, p)

*Purpose*

Removes a variable branching callback function previously added by
XPRSaddcbchgbranch. The specified callback function will no longer be called after it has been removed.

*Synopsis*

int XPRS_CC XPRSremovecbchgbranch(XPRSprob prob, void (XPRS_CC *f_chgbranch)(XPRSprob prob, void* vContext, int* entity, int* up, double* estdeg), void* object);

*Arguments*

`prob`: The current problem.
`f_chgbranch`: The callback function to remove. If NULL then all variable branching callback functions added with the given user-defined object value will be removed.
`object`: The object value that the callback was added with. If NULL, then the object value will not be checked and all variable branching callbacks with the function pointer

*Example*



*Related*

XPRSaddcbchgbranch.
"""
function removecbchgbranch(prob::XpressProblem, f_chgbranch, p)
    @checked Lib.XPRSremovecbchgbranch(prob, f_chgbranch, p)
end

function setcbestimate(prob::XpressProblem, f_estimate, p)
    @checked Lib.XPRSsetcbestimate(prob, f_estimate, p)
end

function getcbestimate(prob::XpressProblem, f_estimate, p)
    @checked Lib.XPRSgetcbestimate(prob, f_estimate, p)
end

"""

    addcbestimate(prob::XpressProblem, f_estimate, p, priority)

*Purpose*

This function is deprecated and may be removed in future releases. Please use branching objects instead. Declares an estimate
callback function. If defined, it will be called at each node of the branch and bound tree to determine the estimated
degradation from
branching the user's global entities. This callback function will be called in addition to any callbacks already added by XPRSaddcbestimate.

*Synopsis*

int XPRS_CC XPRSaddcbestimate(XPRSprob prob, int (XPRS_CC *f_estimate)(XPRSprob my_prob, void *my_object, int *iglsel, int *iprio, double *degbest, double *degworst, double *curval, int *ifupx, int *nglinf, double *degsum, int *nbr), void *object, int priority);

*Arguments*

`prob`: The current problem.
`f_estimate`: The callback function which takes eleven arguments,
`my_prob,`: my_object,
`iglsel,`: iprio,
`degbest,`: degworst,
`curval,`: ifupx,
`nglinf,`: degsum and
`nbr, and has an integer return value. This function is called at each node of the branch and bound search.`: my_prob
`The problem passed to the callback function,`: f_estimate.
`my_object`: The user-defined object passed as
`object when setting up the callback with`: XPRSaddcbestimate.
`iglsel`: Selected user global entity. Must be non-negative or -1 to indicate that there is no user global entity candidate for branching. If set to -1, all other arguments, except for
`nglinf and`: degsum are ignored. This argument is initialized to -1.
`iprio`: Priority of selected user global entity. This argument is initialized to a value larger (i.e., lower priority) than the default priority for global entities (see Section
`Variable Selection for Branching in Section`: Branch and Bound).
`degbest`: Estimated degradation from branching on selected user entity in preferred direction.
`degworst`: Estimated degradation from branching on selected user entity in worst direction.
`curval`: Current value of user global entities.
`ifupx`: Preferred branch on user global entity (
`0,...,`: nbr-1).
`nglinf`: Number of infeasible user global entities.
`degsum`: Sum of estimated degradations of satisfying all user entities.
`nbr`: Number of branches. The user separate routine (set up with
`XPRSaddcbsepnode) will be called`: nbr times in order to create the actual branches.
`object`: A user-defined object to be passed to the callback function,
`f_estimate.`: priority

*Example*



*Related*

XPRSremovecbestimate,
XPRSsetbranchcuts,
XPRSaddcbsepnode,
XPRS_bo_create.
"""
function addcbestimate(prob::XpressProblem, f_estimate, p, priority)
    @checked Lib.XPRSaddcbestimate(prob, f_estimate, p, priority)
end

"""

    removecbestimate(prob::XpressProblem, f_estimate, p)

*Purpose*

Removes an estimate callback function previously added by
XPRSaddcbestimate. The specified callback function will no longer be called after it has been removed.

*Synopsis*

int XPRS_CC XPRSremovecbestimate(XPRSprob prob, int (XPRS_CC *f_estimate)(XPRSprob prob, void* vContext, int* iglsel, int* iprio, double* degbest, double* degworst, double* curval, int* ifupx, int* nglinf, double* degsum, int* nbr), void* object);

*Arguments*

`prob`: The current problem.
`f_estimate`: The callback function to remove. If NULL then all integer solution callback functions added with the given user-defined object value will be removed.
`object`: The object value that the callback was added with. If NULL, then the object value will not be checked and all estimate callbacks with the function pointer

*Example*



*Related*

XPRSaddcbestimate
"""
function removecbestimate(prob::XpressProblem, f_estimate, p)
    @checked Lib.XPRSremovecbestimate(prob, f_estimate, p)
end

function setcbsepnode(prob::XpressProblem, f_sepnode, p)
    @checked Lib.XPRSsetcbsepnode(prob, f_sepnode, p)
end

function getcbsepnode(prob::XpressProblem, f_sepnode, p)
    @checked Lib.XPRSgetcbsepnode(prob, f_sepnode, p)
end

"""

    addcbsepnode(prob::XpressProblem, f_sepnode, p, priority)

*Purpose*

This function is deprecated and may be removed in future releases. Please use branching objects instead. Declares a separate
callback function to specify how to branch on a
node in the branch and bound tree using a global object. A node can be branched by applying either
cuts or
bounds to each node. These are stored in the
cut pool. This callback function will be called in addition to any callbacks already added by XPRSaddcbsepnode.

*Synopsis*

int XPRS_CC XPRSaddcbsepnode(XPRSprob prob, int (XPRS_CC *f_sepnode)(XPRSprob my_prob, void *my_object, int ibr, int iglsel, int ifup, double curval), void *object, int priority);

*Arguments*

`prob`: The current problem.
`f_sepnode`: The callback function, which takes six arguments,
`my_prob,`: my_object,
`ibr,`: iglsel,
`ifup and`: curval, and has an integer return value.
`my_prob`: The problem passed to the callback function,
`f_sepnode.`: my_object
`The user-defined object passed as`: object when setting up the callback with
`XPRSaddcbsepnode.`: ibr
`The branch number.`: iglsel
`The global entity number.`: ifup
`The direction of branch on the global entity (same as`: ibr).
`curval`: Current value of the global entity.
`object`: A user-defined object to be passed to the callback function,
`f_sepnode .`: priority

*Example*

This example solves a MIP, using a separation callback function to branch on fractional integer variables. It assumes the presence of an estimation callback function (not shown), defined by
XPRSaddcbestimate, to identify a fractional integer variable.

*Related*

XPRSremovecbsepnode,
XPRSsetbranchbounds,
XPRSsetbranchcuts,
XPRSaddcbestimate,
XPRSstorebounds,
XPRSstorecuts.
"""
function addcbsepnode(prob::XpressProblem, f_sepnode, p, priority)
    @checked Lib.XPRSaddcbsepnode(prob, f_sepnode, p, priority)
end

"""

    removecbsepnode(prob::XpressProblem, f_sepnode, p)

*Purpose*

Removes a pre-integer solution callback function previously added by
XPRSaddcbsepnode. The specified callback function will no longer be called after it has been removed.

*Synopsis*

int XPRS_CC XPRSremovecbsepnode(XPRSprob prob, int (XPRS_CC *f_sepnode)(XPRSprob prob, void* vContext, int ibr, int iglsel, int ifup, double curval), void* object);

*Arguments*

`prob`: The current problem.
`f_sepnode`: The callback function to remove. If NULL then all separation callback functions added with the given user-defined object value will be removed.
`object`: The object value that the callback was added with. If NULL, then the object value will not be checked and all separation callbacks with the function pointer

*Example*



*Related*

XPRSaddcbsepnode
"""
function removecbsepnode(prob::XpressProblem, f_sepnode, p)
    @checked Lib.XPRSremovecbsepnode(prob, f_sepnode, p)
end

function setcbmessage(prob::XpressProblem, f_message, p)
    @checked Lib.XPRSsetcbmessage(prob, f_message, p)
end

function getcbmessage(prob::XpressProblem, f_message, p)
    @checked Lib.XPRSgetcbmessage(prob, f_message, p)
end

"""

    addcbmessage(prob::XpressProblem, f_message, p, priority)

*Purpose*

Declares an output
callback function, called every time a text line relating to the given XPRSprob is output by the Optimizer. This callback function will be called in addition to any callbacks already added by XPRSaddcbmessage.

*Synopsis*

int XPRS_CC XPRSaddcbmessage(XPRSprob prob, void (XPRS_CC *f_message)(XPRSprob my_prob, void *my_object, const char *msg, int len, int msgtype), void *object, int priority);

*Arguments*

`prob`: The current problem.
`f_message`: The callback function which takes five arguments,
`my_prob,`: my_object,
`msg,`: len and
`msgtype, and has no return value. Use a`: NULL value to cancel a callback function.
`my_prob`: The problem passed to the callback function.
`my_object`: The user-defined object passed as
`object when setting up the callback with`: XPRSaddcbmessage.
`msg`: A null terminated character array (string) containing the message, which may simply be a new line.
`len`: The length of the message string, excluding the null terminator.
`msgtype`: Indicates the type of output message:
`1`: information messages;
`2`: (not used);
`3`: warning messages;
`4`: error messages.
`A negative value indicates that the Optimizer is about to finish and the buffers should be flushed at this time if the output is being redirected to a file.`: object
`A user-defined object to be passed to the callback function.`: priority

*Example*

The following example simply sends all output to the screen (
stdout):

*Related*

XPRSremovecbmessage,
XPRSaddcbbarlog,
XPRSaddcbgloballog,
XPRSaddcblplog,
XPRSsetlogfile.
"""
function addcbmessage(prob::XpressProblem, f_message, p, priority)
    @checked Lib.XPRSaddcbmessage(prob, f_message, p, priority)
end

"""

    removecbmessage(prob::XpressProblem, f_message, p)

*Purpose*

Removes a message callback function previously added by
XPRSaddcbmessage. The specified callback function will no longer be called after it has been removed.

*Synopsis*

int XPRS_CC XPRSremovecbmessage(XPRSprob prob, void (XPRS_CC *f_message)(XPRSprob prob, void* vContext, const char* msg, int len, int msgtype), void* object);

*Arguments*

`prob`: The current problem.
`f_message`: The callback function to remove. If NULL then all message callback functions added with the given user-defined object value will be removed.
`object`: The object value that the callback was added with. If NULL, then the object value will not be checked and all message callbacks with the function pointer

*Example*



*Related*

XPRSaddcbmessage
"""
function removecbmessage(prob::XpressProblem, f_message, p)
    @checked Lib.XPRSremovecbmessage(prob, f_message, p)
end

function setcbmipthread(prob::XpressProblem, f_mipthread, p)
    @checked Lib.XPRSsetcbmipthread(prob, f_mipthread, p)
end

function getcbmipthread(prob::XpressProblem, f_mipthread, p)
    @checked Lib.XPRSgetcbmipthread(prob, f_mipthread, p)
end

"""

    addcbmipthread(prob::XpressProblem, f_mipthread, p, priority)

*Purpose*

Declares a MIP thread callback function, called every time a MIP worker problem is created by the parallel MIP code. This callback function will be called in addition to any callbacks already added by XPRSaddcbmipthread.

*Synopsis*

int XPRS_CC XPRSaddcbmipthread(XPRSprob prob, void (XPRS_CC *f_mipthread)(XPRSprob my_prob, void *my_object, XPRSprob thread_prob), void *object, int priority);

*Arguments*

`prob`: The current problem.
`f_mipthread`: The callback function which takes three arguments,
`my_prob,`: my_object and
`thread_prob, and has no return value.`: my_prob
`The problem passed to the callback function.`: my_object
`The user-defined object passed to the callback function.`: thread_prob
`The problem pointer for the MIP thread`: object
`A user-defined object to be passed to the callback function.`: priority

*Example*

The following example clears the message callback for each of the MIP threads:

*Related*

XPRSremovecbmipthread,
XPRSaddcbdestroymt,
MIPTHREADS,
MAXMIPTASKS.
"""
function addcbmipthread(prob::XpressProblem, f_mipthread, p, priority)
    @checked Lib.XPRSaddcbmipthread(prob, f_mipthread, p, priority)
end

"""

    removecbmipthread(prob::XpressProblem, f_mipthread, p)

*Purpose*

Removes a callback function previously added by
XPRSaddcbmipthread. The specified callback function will no longer be called after it has been removed.

*Synopsis*

int XPRS_CC XPRSremovecbmipthread(XPRSprob prob, void (XPRS_CC *f_mipthread)(XPRSprob master_prob, void* vContext, XPRSprob prob), void* object);

*Arguments*

`prob`: The current problem.
`f_mipthread`: The callback function to remove. If NULL then all variable branching callback functions added with the given user-defined object value will be removed.
`object`: The object value that the callback was added with. If NULL, then the object value will not be checked and all variable branching callbacks with the function pointer

*Example*



*Related*

XPRSaddcbmipthread
"""
function removecbmipthread(prob::XpressProblem, f_mipthread, p)
    @checked Lib.XPRSremovecbmipthread(prob, f_mipthread, p)
end

function setcbdestroymt(prob::XpressProblem, f_destroymt, p)
    @checked Lib.XPRSsetcbdestroymt(prob, f_destroymt, p)
end

function getcbdestroymt(prob::XpressProblem, f_destroymt, p)
    @checked Lib.XPRSgetcbdestroymt(prob, f_destroymt, p)
end

"""

    addcbdestroymt(prob::XpressProblem, f_destroymt, p, priority)

*Purpose*

Declares a destroy MIP thread callback function, called every time a MIP thread is destroyed by the parallel MIP code. This callback function will be called in addition to any callbacks already added by XPRSaddcbdestroymt.

*Synopsis*

int XPRS_CC XPRSaddcbdestroymt(XPRSprob prob, void (XPRS_CC *f_destroymt)(XPRSprob my_prob, void *my_object), void *object, int priority);

*Arguments*

`prob`: The current thread problem.
`f_destroymt`: The callback function which takes two arguments,
`my_prob and`: my_object, and has no return value.
`my_prob`: The thread problem passed to the callback function.
`my_object`: The user-defined object passed as
`object when setting up the callback with`: XPRSaddcbdestroymt.
`object`: A user-defined object to be passed to the callback function.
`priority`: An integer that determines the order in which multiple callbacks of this type will be invoked. The callback added with a higher priority will be called before a callback with a lower priority. Set to 0 if not required.

*Example*



*Related*

XPRSremovecbdestroymt,
XPRSaddcbmipthread.
"""
function addcbdestroymt(prob::XpressProblem, f_destroymt, p, priority)
    @checked Lib.XPRSaddcbdestroymt(prob, f_destroymt, p, priority)
end

"""

    removecbdestroymt(prob::XpressProblem, f_destroymt, p)

*Purpose*

Removes a slave thread destruction callback function previously added by
XPRSaddcbdestroymt. The specified callback function will no longer be called after it has been removed.

*Synopsis*

int XPRS_CC XPRSremovecbdestroymt(XPRSprob prob, void (XPRS_CC *f_destroymt)(XPRSprob prob, void* vContext), void* object);

*Arguments*

`prob`: The current problem.
`f_destroymt`: The callback function to remove. If NULL then all thread destruction callback functions added with the given user-defined object value will be removed.
`object`: The object value that the callback was added with. If NULL, then the object value will not be checked and all thread destruction callbacks with the function pointer

*Example*



*Related*

XPRSaddcbdestroymt
"""
function removecbdestroymt(prob::XpressProblem, f_destroymt, p)
    @checked Lib.XPRSremovecbdestroymt(prob, f_destroymt, p)
end

function setcbnewnode(prob::XpressProblem, f_newnode, p)
    @checked Lib.XPRSsetcbnewnode(prob, f_newnode, p)
end

function getcbnewnode(prob::XpressProblem, f_newnode, p)
    @checked Lib.XPRSgetcbnewnode(prob, f_newnode, p)
end

"""

    addcbnewnode(prob::XpressProblem, f_newnode, p, priority)

*Purpose*

Declares a callback function that will be called every time a new node is created during the branch and bound search. This callback function will be called in addition to any callbacks already added by XPRSaddcbnewnode.

*Synopsis*

int XPRS_CC XPRSaddcbnewnode(XPRSprob prob, void (XPRS_CC *f_newnode)(XPRSprob my_prob, void* my_object, int parentnode, int newnode, int branch), void* object, int priority);

*Arguments*

`prob`: The current problem.
`f_newnode`: The callback function, which takes five arguments:
`myprob,`: my_object,
`parentnode,`: newnode and
`branch. This function is called every time a new node is created through branching.`: my_prob
`The problem passed to the callback function,`: f_newnode.
`my_object`: The user-defined object passed as
`object when setting up the callback with`: XPRSaddcbnewnode.
`parentnode`: Unique identifier for the parent of the new node.
`newnode`: Unique identifier assigned to the new node.
`branch`: The sequence number of the new node amongst the child nodes of
`parentnode. For regular branches on a global entity this will be either`: 0 or
`1.`: object
`A user-defined object to be passed to the callback function.`: priority

*Example*



*Related*

XPRSremovecbnewnode,
XPRSaddcbchgnode.
"""
function addcbnewnode(prob::XpressProblem, f_newnode, p, priority)
    @checked Lib.XPRSaddcbnewnode(prob, f_newnode, p, priority)
end

"""

    removecbnewnode(prob::XpressProblem, f_newnode, p)

*Purpose*

Removes a new-node callback function previously added by
XPRSaddcbnewnode. The specified callback function will no longer be called after it has been removed.

*Synopsis*

int XPRS_CC XPRSremovecbnewnode(XPRSprob prob, void (XPRS_CC *f_newnode)(XPRSprob my_prob, void* my_object, int parentnode, int newnode, int branch), void* object);

*Arguments*

`prob`: The current problem.
`f_newnode`: The callback function to remove. If NULL then all separation callback functions added with the given user-defined object value will be removed.
`object`: The object value that the callback was added with. If NULL, then the object value will not be checked and all separation callbacks with the function pointer

*Example*



*Related*

XPRSaddcbnewnode
"""
function removecbnewnode(prob::XpressProblem, f_newnode, p)
    @checked Lib.XPRSremovecbnewnode(prob, f_newnode, p)
end

function setcbbariteration(prob::XpressProblem, f_bariteration, p)
    @checked Lib.XPRSsetcbbariteration(prob, f_bariteration, p)
end

function getcbbariteration(prob::XpressProblem, f_bariteration, p)
    @checked Lib.XPRSgetcbbariteration(prob, f_bariteration, p)
end

"""

    addcbbariteration(prob::XpressProblem, f_bariteration, p, priority)

*Purpose*

Declares a barrier iteration callback function, called after each iteration during the interior point algorithm, with the ability to access the current barrier solution/slack/duals or reduced cost values, and to ask barrier to stop. This callback function will be called in addition to any callbacks already added by XPRSaddcbbariteration.

*Synopsis*

int XPRS_CC XPRSaddcbbariteration (XPRSprob prob, void (XPRS_CC *f_bariteration)( XPRSprob my_prob, void *my_object, int *barrier_action), void *object, int priority);

*Arguments*

`prob`: The current problem.
`f_bariteration`: The callback function itself. This takes three arguments,
`my_prob,`: my_object, and
`barrier_action serving as an integer return value. This function is called at every barrier iteration.`: my_prob
`The problem passed to the callback function,`: f_bariteration.
`my_object`: The user-defined object passed as
`object when setting up the callback with`: XPRSaddcbbariteration.
`barrier_action`: Defines a return value controlling barrier:
`<0`: continue with the next iteration;
`=0`: let barrier decide (use default stopping criteria);
`1`: barrier stops with status not defined;
`2`: barrier stops with optimal status;
`3`: barrier stops with dual infeasible status;
`4`: barrier stops wih primal infeasible status;
`object`: A user-defined object to be passed to the callback function,
`f_bariteration.`: priority

*Example*

This simple example demonstrates how the solution might be retrieved for each barrier iteration.

*Related*

XPRSremovecbbariteration.
"""
function addcbbariteration(prob::XpressProblem, f_bariteration, p, priority)
    @checked Lib.XPRSaddcbbariteration(prob, f_bariteration, p, priority)
end

"""

    removecbbariteration(prob::XpressProblem, f_bariteration, p)

*Purpose*

Removes a barrier iteration callback function previously added by
XPRSaddcbbariteration. The specified callback function will no longer be called after it has been removed.

*Synopsis*

int XPRS_CC XPRSremovecbbariteration(XPRSprob prob, void (XPRS_CC *f_bariteration)(XPRSprob prob, void* vContext, int* barrier_action), void* object);

*Arguments*

`prob`: The current problem.
`f_bariteration`: The callback function to remove. If NULL then all bariteration callback functions added with the given user-defined object value will be removed.
`object`: The object value that the callback was added with. If NULL, then the object value will not be checked and all barrier iteration callbacks with the function pointer

*Example*



*Related*

XPRSaddcbbariteration.
"""
function removecbbariteration(prob::XpressProblem, f_bariteration, p)
    @checked Lib.XPRSremovecbbariteration(prob, f_bariteration, p)
end

function setcbchgbranchobject(prob::XpressProblem, f_chgbranchobject, p)
    @checked Lib.XPRSsetcbchgbranchobject(prob, f_chgbranchobject, p)
end

function getcbchgbranchobject(prob::XpressProblem, f_chgbranchobject, p)
    @checked Lib.XPRSgetcbchgbranchobject(prob, f_chgbranchobject, p)
end

"""

    addcbchgbranchobject(prob::XpressProblem, f_chgbranchobject, p, priority)

*Purpose*

Declares a callback function that will be called every time the Optimizer has selected a global entity for branching. Allows the user to inspect and override the Optimizer's branching choice. This callback function will be called in addition to any callbacks already added by XPRSaddcbchgbranchobject.

*Synopsis*

int XPRS_CC XPRSaddcbchgbranchobject(XPRSprob prob, void (XPRS_CC *f_chgbranchobject)(XPRSprob my_prob, void* my_object, XPRSbranchobject obranch, XPRSbranchobject* p_newobject), void* object, int priority);

*Arguments*

`prob`: The current problem.
`f_chgbranchobject`: The callback function, which takes four arguments:
`my_prob,`: my_object,
`obranch and`: p_newobject. This function is called every time the Optimizer has selected a candidate entity for branching.
`my_prob`: The problem passed to the callback function,
`f_chgbranchobject.`: my_object
`The user defined object passed as`: object when setting up the callback with
`XPRSaddcbchgbranchobject.`: obranch
`The candidate branching object selected by the Optimizer.`: p_newobject
`Optional new branching object to replace the Optimizer's selection.`: object
`A user-defined object to be passed to the callback function,`: f_chgbranchobject.
`priority`: An integer that determines the order in which multiple callbacks of this type will be invoked. The callback added with a higher priority will be called before a callback with a lower priority. Set to 0 if not required.

*Example*



*Related*

XPRSremovecbchgbranchobject,
XPRS_bo_create.
"""
function addcbchgbranchobject(prob::XpressProblem, f_chgbranchobject, p, priority)
    @checked Lib.XPRSaddcbchgbranchobject(prob, f_chgbranchobject, p, priority)
end

"""

    removecbchgbranchobject(prob::XpressProblem, f_chgbranchobject, p)

*Purpose*

Removes a callback function previously added by
XPRSaddcbchgbranchobject. The specified callback function will no longer be called after it has been removed.

*Synopsis*

int XPRS_CC XPRSremovecbchgbranchobject(XPRSprob prob, void (XPRS_CC *f_chgbranchobject)(XPRSprob my_prob, void* my_object, XPRSbranchobject obranch, XPRSbranchobject* p_newobject), void* object);

*Arguments*

`prob`: The current problem.
`f_chgbranchobject`: The callback function to remove. If NULL then all branch object callback functions added with the given user-defined object value will be removed.
`object`: The object value that the callback was added with. If NULL, then the object value will not be checked and all branch object callbacks with the function pointer

*Example*



*Related*

XPRSaddcbchgbranchobject
"""
function removecbchgbranchobject(prob::XpressProblem, f_chgbranchobject, p)
    @checked Lib.XPRSremovecbchgbranchobject(prob, f_chgbranchobject, p)
end

function setcbgapnotify(prob::XpressProblem, f_gapnotify, p)
    @checked Lib.XPRSsetcbgapnotify(prob, f_gapnotify, p)
end

function getcbgapnotify(prob::XpressProblem, f_gapnotify, p)
    @checked Lib.XPRSgetcbgapnotify(prob, f_gapnotify, p)
end

"""

    addcbgapnotify(prob::XpressProblem, f_gapnotify, p, priority)

*Purpose*

Declares a gap notification callback, to be called when a MIP solve reaches a predefined target, set using the
MIPRELGAPNOTIFY,
MIPABSGAPNOTIFY,
MIPABSGAPNOTIFYOBJ and/or
MIPABSGAPNOTIFYBOUND controls.

*Synopsis*

int XPRS_CC XPRSaddcbgapnotify(XPRSprob prob, void (XPRS_CC *f_gapnotify)(XPRSprob my_prob, void* my_object, double* newRelGapNotifyTarget, double* newAbsGapNotifyTarget, double* newAbsGapNotifyObjTarget, double* newAbsGapNotifyBoundTarget), void* object, int priority);

*Arguments*

`prob`: The current problem.
`f_gapnotify`: The callback function.
`my_prob`: The current problem.
`my_object`: The user-defined object passed as
`object when setting up the callback with`: XPRSaddcbgapnotify.
`newRelGapNotifyTarget`: The value the
`MIPRELGAPNOTIFY control will be set to after this callback. May be modified within the callback in order to set a new notification target.`: newAbsGapNotifyTarget
`The value the`: MIPABSGAPNOTIFY control will be set to after this callback. May be modified within the callback in order to set a new notification target.
`newAbsGapNotifyObjTarget`: The value the
`MIPABSGAPNOTIFYOBJ control will be set to after this callback. May be modified within the callback in order to set a new notification target.`: newAbsGapNotifyBoundTarget
`The value the`: MIPABSGAPNOTIFYBOUND control will be set to after this callback. May be modified within the callback in order to set a new notification target.
`object`: A user-defined object to be passed to the callback function,
`f_gapnotify.`: priority

*Example*

The following example prints a message when the gap reaches 10% and 1%

*Related*

MIPRELGAPNOTIFY,
MIPABSGAPNOTIFY,
MIPABSGAPNOTIFYOBJ,
MIPABSGAPNOTIFYBOUND,
XPRSremovecbgapnotify.
"""
function addcbgapnotify(prob::XpressProblem, f_gapnotify, p, priority)
    @checked Lib.XPRSaddcbgapnotify(prob, f_gapnotify, p, priority)
end

"""

    removecbgapnotify(prob::XpressProblem, f_gapnotify, p)

*Purpose*

Removes a callback function previously added by
XPRSaddcbgapnotify. The specified callback function will no longer be removed after it has been returned.

*Synopsis*

int XPRS_CC XPRSremovecbgapnotify(XPRSprob prob, void (XPRS_CC *f_gapnotify)(XPRSprob prob, void* vContext, double* newRelGapNotifyTarget, double* newAbsGapNotifyTarget, double* newAbsGapNotifyObjTarget, double* newAbsGapNotifyBoundTarget), void* p);

*Arguments*

`prob`: The current problem.
`f_gapnotify`: The callback function to remove. If
`NULL then all`: gapnotify callback functions added with the given user-defined pointer value will be removed.
`p`: The user-defined pointer value that the callback was added with. If
`NULL then the pointer value will not be checked and all the`: gapnotify callbacks with the function pointer

*Example*



*Related*

XPRSaddcbgapnotify.
"""
function removecbgapnotify(prob::XpressProblem, f_gapnotify, p)
    @checked Lib.XPRSremovecbgapnotify(prob, f_gapnotify, p)
end

function setcbusersolnotify(prob::XpressProblem, f_usersolnotify, p)
    @checked Lib.XPRSsetcbusersolnotify(prob, f_usersolnotify, p)
end

function getcbusersolnotify(prob::XpressProblem, f_usersolnotify, p)
    @checked Lib.XPRSgetcbusersolnotify(prob, f_usersolnotify, p)
end

"""

    addcbusersolnotify(prob::XpressProblem, f_usersolnotify, p, priority)

*Purpose*

Declares a callback function to be called each time a solution added by
XPRSaddmipsol has been processed. This callback function will be called in addition to any callbacks already added by
XPRSaddcbusersolnotify.

*Synopsis*

int XPRS_CC XPRSaddcbusersolnotify(XPRSprob prob, void (XPRS_CC *f_usersolnotify)(XPRSprob my_prob, void* my_object, const char* solname, int status), void* object, int priority);

*Arguments*

`prob`: The current problem.
`f_usersolnotify`: The callback function which takes four arguments,
`my_prob,`: my_object,
`id and`: status and has no return value.
`my_prob`: The problem passed to the callback function,
`f_usersolnotify.`: my_object
`The user-defined object passed as object when setting up the callback with`: XPRSaddcbusersolnotify.
`solname`: The string name assigned to the solution when it was loaded into the Optimizer using
`XPRSaddmipsol.`: status
`One of the following status values:`: 0
`An error occurred while processing the solution.`: 1
`Solution is feasible.`: 2
`Solution is feasible after reoptimizing with fixed globals.`: 3
`A local search heuristic was applied and a feasible solution discovered.`: 4
`A local search heuristic was applied but a feasible solution was not found.`: 5
`Solution is infeasible and a local search could not be applied.`: 6
`Solution is partial and a local search could not be applied.`: 7
`Failed to reoptimize the problem with globals fixed to the provided solution. Likely because a time or iteration limit was reached.`: 8
`Solution is dropped. This can happen if the MIP problem is changed or solved to completion before the solution could be processed.`: object
`A user-defined object to be passed to the callback function,`: f_usersolnotify.
`priority`: An integer that determines the order in which multiple callbacks will be invoked. The callback added with a higher priority will be called before a callback with a lower priority. Set to

*Example*



*Related*

XPRSremovecbusersolnotify,
XPRSaddmipsol.
"""
function addcbusersolnotify(prob::XpressProblem, f_usersolnotify, p, priority)
    @checked Lib.XPRSaddcbusersolnotify(prob, f_usersolnotify, p, priority)
end

"""

    removecbusersolnotify(prob::XpressProblem, f_usersolnotify, p)

*Purpose*

Removes a user solution notification callback previously added by
XPRSaddcbusersolnotify. The specified callback function will no longer be called after it has been removed.

*Synopsis*

int XPRS_CC XPRSremovecbusersolnotify(XPRSprob prob, void (XPRS_CC *f_usersolnotify)(XPRSprob my_prob, void* my_object, const char* solname, int status), void* object);

*Arguments*

`prob`: The current problem.
`f_usersolnotify`: The callback function to remove. If
`NULL then all user solution notification callback functions added with the given user defined object value will be removed.`: object
`The object value that the callback was added with. If`: NULL, then the object value will not be checked and all integer solution callbacks with the function pointer

*Example*



*Related*

XPRSaddcbusersolnotify.
"""
function removecbusersolnotify(prob::XpressProblem, f_usersolnotify, p)
    @checked Lib.XPRSremovecbusersolnotify(prob, f_usersolnotify, p)
end

"""

    objsa(prob::XpressProblem, ncols, mindex, lower, upper)

*Purpose*

Returns upper and lower sensitivity ranges for specified objective function coefficients. If the objective coefficients are varied within these ranges the current basis remains optimal and the reduced costs remain valid.

*Synopsis*

int XPRS_CC XPRSobjsa(XPRSprob prob, int nels, const int mindex[], double lower[], double upper[]);

*Arguments*

`prob`: The current problem.
`nels`: Number of objective function coefficients whose sensitivity is sought.
`mindex`: Integer array of length
`nels containing the indices of the columns whose objective function coefficients sensitivity ranges are required.`: lower
`Double array of length`: nels where the objective function lower range values are to be returned.
`upper`: Double array of length

*Example*

Here we obtain the objective function ranges for the three columns:
2,
6 and
8:

*Related*

XPRSrhssa.
"""
function objsa(prob::XpressProblem, ncols, mindex, lower, upper)
    @checked Lib.XPRSobjsa(prob, ncols, mindex, lower, upper)
end

"""

    rhssa(prob::XpressProblem, nrows, mindex, lower, upper)

*Purpose*

Returns upper and lower sensitivity ranges for specified right hand side (RHS) function coefficients. If the RHS coefficients are varied within these ranges the current basis remains optimal and the reduced costs remain valid.

*Synopsis*

int XPRS_CC XPRSrhssa(XPRSprob prob, int nels, const int mindex[], double lower[], double upper[]);

*Arguments*

`prob`: The current problem.
`nels`: The number of RHS coefficients for which sensitivity ranges are required.
`mindex`: Integer array of length
`nels containing the indices of the rows whose RHS coefficients sensitivity ranges are required.`: lower
`Double array of length`: nels where the RHS lower range values are to be returned.
`upper`: Double array of length

*Example*

Here we obtain the RHS function ranges for the three columns:
2,
6 and
8:

*Related*

XPRSobjsa.
"""
function rhssa(prob::XpressProblem, nrows, mindex, lower, upper)
    @checked Lib.XPRSrhssa(prob, nrows, mindex, lower, upper)
end

"""

    _ge_setcbmsghandler(f_msghandler, p)

*Purpose*

This function is deprecated and may be removed in future releases. Please use XPRS_ge_addcbmsghandler instead.  Declares an output callback function, called every time a line of message text is output by any object in the library.

*Synopsis*

int XPRS_CC XPRS_ge_setcbmsghandler(int (XPRS_CC *f_msghandler)(XPRSobject vXPRSObject, void * vUserContext, void * vSystemThreadId, const char * sMsg, int iMsgType, int iMsgNumber), void * p);

*Arguments*

`f_msghandler`: The callback function which takes six arguments,
`vXPRSObject,`: vUserContext,
`vSystemThreadId,`: sMsg,
`iMsgType and`: iMsgNumber. Use a NULL value to cancel a callback function.
`vXPRSObject`: The object sending the message. Use
`XPRSgetobjecttypename to get the name of the object type.`: vUserContext
`The user-defined object passed to the callback function.`: vSystemThreadId
`The system id of the thread sending the message caste to a void *.`: sMsg
`A null terminated character array (string) containing the message, which may simply be a new line. When the callback is called for the first time`: sMsg will be a NULL pointer.
`iMsgType`: Indicates the type of output message:
`1`: information messages;
`2`: (not used);
`3`: warning messages;
`4`: error messages.
`A negative value means the callback is being called for the first time.`: iMsgNumber
`The number associated with the message. If the message is an error or a warning then you can look up the number in the section Optimizer Error and Warning Messages for advice on what it means and how to resolve the associated issue.`: p

*Example*



*Related*

XPRSgetobjecttypename.
"""
function _ge_setcbmsghandler(f_msghandler, p)
    @checked Lib.XPRS_ge_setcbmsghandler(f_msghandler, p)
end

"""

    _ge_getcbmsghandler(f_msghandler, p)

*Purpose*

This function is deprecated and may be removed in future releases.  Get the output callback function for the global environment, as set by
XPRS_ge_setcbmsghander.

*Synopsis*

int XPRS_CC XPRS_ge_getcbmsghandler(int (XPRS_CC **r_f_msghandler)(XPRSobject vXPRSObject, void * vUserContext, void * vSystemThreadId, const char * sMsg, int iMsgType, int iMsgNumber), void **object);

*Arguments*

`r_f_msghandler`: Pointer to the memory where the callback function will be returned.
`object`: Pointer to the memory where the callback function context value will be returned.

*Example*



*Related*

XPRS_ge_setcbmsghandler.
"""
function _ge_getcbmsghandler(f_msghandler, p)
    @checked Lib.XPRS_ge_getcbmsghandler(f_msghandler, p)
end

"""

    _ge_addcbmsghandler(f_msghandler, p, priority)

*Purpose*

Declares an output
callback function in the global environment, called every time a line of message text is output by any object in the library. This callback function will be called in addition to any output callbacks already added by
XPRS_ge_addcbmsghandler.

*Synopsis*

int XPRS_CC XPRS_ge_addcbmsghandler(int (XPRS_CC *f_msghandler)(XPRSobject vXPRSObject, void * vUserContext, void * vSystemThreadId, const char * sMsg, int iMsgType, int iMsgNumber), void *object, int priority);

*Arguments*

`f_msghandler`: The callback function which takes six arguments,
`vXPRSObject,`: vUserContext,
`vSystemThreadId,`: sMsg,
`iMsgType and`: iMsgNumber. Use a NULL value to cancel a callback function.
`vXPRSObject`: The object sending the message. Use
`XPRSgetobjecttypename to get the name of the object type.`: vUserContext
`The user-defined object passed to the callback function.`: vSystemThreadId
`The system id of the thread sending the message cast to a`: void *.
`sMsg`: A null terminated character array (string) containing the message, which may simply be a new line. When the callback is called for the first time
`sMsg will be a NULL pointer.`: iMsgType
`Indicates the type of output message:`: 1
`information messages;`: 2
`(not used);`: 3
`warning messages;`: 4
`error messages.`: When the callback is called for the first time
`iMsgType will be a negative value.`: iMsgNumber
`The number associated with the message. If the message is an error or a warning then you can look up the number in the section Optimizer Error and Warning Messages for advice on what it means and how to resolve the associated issue.`: object
`A user-defined object to be passed to the callback function.`: priority

*Example*



*Related*

XPRS_ge_removecbmsghandler,
XPRSgetobjecttypename.
"""
function _ge_addcbmsghandler(f_msghandler, p, priority)
    @checked Lib.XPRS_ge_addcbmsghandler(f_msghandler, p, priority)
end

"""

    _ge_removecbmsghandler(f_msghandler, p)

*Purpose*

Removes a message callback function previously added by
XPRS_ge_addcbmsghandler. The specified callback function will no longer be called after it has been removed.

*Synopsis*

int XPRS_CC XPRS_ge_removecbmsghandler(int (XPRS_CC *f_msghandler)(XPRSobject vXPRSObject, void * vUserContext, void * vSystemThreadId, const char * sMsg, int iMsgType, int iMsgNumber), void * object);

*Arguments*

`f_msghandler`: The callback function to remove. If NULL then all message callback functions added with the given user-defined object value will be removed.
`object`: The object value that the callback was added with. If NULL, then the object value will not be checked and all message callbacks with the function pointer

*Example*



*Related*

XPRS_ge_addcbmsghandler
"""
function _ge_removecbmsghandler(f_msghandler, p)
    @checked Lib.XPRS_ge_removecbmsghandler(f_msghandler, p)
end

"""

    _ge_getlasterror(iMsgCode, _msg, _iStringBufferBytes, _iBytesInInternalString)

*Purpose*

Returns the last error encountered during a call to the Xpress global environment.

*Synopsis*

int XPRS_CC XPRS_ge_getlasterror(int* iMsgCode, char* _msg, int _iStringBufferBytes, int* _iBytesInInternalString);

*Arguments*

`iMsgCode`: Memory location in which the error code will be returned. Can be NULL if not required.
`_msg`: A character buffer of size
`iStringBufferBytes in which the last error message relating to the global environment will be returned.`: iStringBufferBytes
`The size of the character buffer`: _msg.
`_iBytesInInternalString`: Memory location in which the minimum required size of the buffer to hold the full error string will be returned. Can be NULL if not required.

*Example*

The following shows how this function might be used in error checking:

*Related*

XPRS_ge_setcbmsghandler.
"""
function _ge_getlasterror(iMsgCode, _msg, _iStringBufferBytes, _iBytesInInternalString)
    @checked Lib.XPRS_ge_getlasterror(iMsgCode, _msg, _iStringBufferBytes, _iBytesInInternalString)
end

function _msp_create(msp)
    @checked Lib.XPRS_msp_create(msp)
end

function _msp_destroy(msp)
    @checked Lib.XPRS_msp_destroy(msp)
end

function _msp_probattach(msp, prob)
    @checked Lib.XPRS_msp_probattach(msp, prob)
end

function _msp_probdetach(msp, prob)
    @checked Lib.XPRS_msp_probdetach(msp, prob)
end

function _msp_getsollist(msp, prob_to_rank_against, iRankAttrib, bRankAscending, iRankFirstIndex_Ob, iRankLastIndex_Ob, iSolutionIds_Zb, nReturnedSolIds, nSols)
    @checked Lib.XPRS_msp_getsollist(msp, prob_to_rank_against, iRankAttrib, bRankAscending, iRankFirstIndex_Ob, iRankLastIndex_Ob, iSolutionIds_Zb, nReturnedSolIds, nSols)
end

function _msp_getsollist2(msp, prob_to_rank_against, iRankAttrib, bRankAscending, iRankFirstIndex_Ob, iRankLastIndex_Ob, bUseUserBitFilter, iUserBitMask, iUserBitPattern, bUseInternalBitFilter, iInternalBitMask, iInternalBitPattern, iSolutionIds_Zb, nReturnedSolIds, nSols)
    @checked Lib.XPRS_msp_getsollist2(msp, prob_to_rank_against, iRankAttrib, bRankAscending, iRankFirstIndex_Ob, iRankLastIndex_Ob, bUseUserBitFilter, iUserBitMask, iUserBitPattern, bUseInternalBitFilter, iInternalBitMask, iInternalBitPattern, iSolutionIds_Zb, nReturnedSolIds, nSols)
end

function _msp_getsol(msp, iSolutionId, iSolutionIdStatus_, x, iColFirst, iColLast, nValuesReturned)
    @checked Lib.XPRS_msp_getsol(msp, iSolutionId, iSolutionIdStatus_, x, iColFirst, iColLast, nValuesReturned)
end

function _msp_getslack(msp, prob_to_rank_against, iSolutionId, iSolutionIdStatus_, slack, iRowFirst, iRowLast, nValuesReturned)
    @checked Lib.XPRS_msp_getslack(msp, prob_to_rank_against, iSolutionId, iSolutionIdStatus_, slack, iRowFirst, iRowLast, nValuesReturned)
end

function _msp_loadsol(msp, iSolutionId, x, nCols, sSolutionName, bNameModifiedForUniqueness, iSolutionIdOfExistingDuplicatePreventedLoad)
    @checked Lib.XPRS_msp_loadsol(msp, iSolutionId, x, nCols, sSolutionName, bNameModifiedForUniqueness, iSolutionIdOfExistingDuplicatePreventedLoad)
end

function _msp_delsol(msp, iSolutionId, iSolutionIdStatus_)
    @checked Lib.XPRS_msp_delsol(msp, iSolutionId, iSolutionIdStatus_)
end

function _msp_getintattribprobsol(msp, prob_to_rank_against, iSolutionId, iSolutionIdStatus_, iAttribId, Dst)
    @checked Lib.XPRS_msp_getintattribprobsol(msp, prob_to_rank_against, iSolutionId, iSolutionIdStatus_, iAttribId, Dst)
end

function _msp_getdblattribprobsol(msp, prob_to_rank_against, iSolutionId, iSolutionIdStatus_, iAttribId, Dst)
    @checked Lib.XPRS_msp_getdblattribprobsol(msp, prob_to_rank_against, iSolutionId, iSolutionIdStatus_, iAttribId, Dst)
end

function _msp_getintattribprob(msp, prob::XpressProblem, iAttribId, Dst)
    @checked Lib.XPRS_msp_getintattribprob(msp, prob, iAttribId, Dst)
end

function _msp_getdblattribprob(msp, prob::XpressProblem, iAttribId, Dst)
    @checked Lib.XPRS_msp_getdblattribprob(msp, prob, iAttribId, Dst)
end

function _msp_getintattribsol(msp, iSolutionId, iSolutionIdStatus_, iAttribId, Dst)
    @checked Lib.XPRS_msp_getintattribsol(msp, iSolutionId, iSolutionIdStatus_, iAttribId, Dst)
end

function _msp_getdblattribsol(msp, iSolutionId, iSolutionIdStatus_, iAttribId, Dst)
    @checked Lib.XPRS_msp_getdblattribsol(msp, iSolutionId, iSolutionIdStatus_, iAttribId, Dst)
end

function _msp_getintcontrolsol(msp, iSolutionId, iSolutionIdStatus_, iControlId, Val)
    @checked Lib.XPRS_msp_getintcontrolsol(msp, iSolutionId, iSolutionIdStatus_, iControlId, Val)
end

function _msp_getdblcontrolsol(msp, iSolutionId, iSolutionIdStatus_, iControlId, Val)
    @checked Lib.XPRS_msp_getdblcontrolsol(msp, iSolutionId, iSolutionIdStatus_, iControlId, Val)
end

function _msp_setintcontrolsol(msp, iSolutionId, iSolutionIdStatus_, iControlId, Val)
    @checked Lib.XPRS_msp_setintcontrolsol(msp, iSolutionId, iSolutionIdStatus_, iControlId, Val)
end

function _msp_setdblcontrolsol(msp, iSolutionId, iSolutionIdStatus_, iControlId, Val)
    @checked Lib.XPRS_msp_setdblcontrolsol(msp, iSolutionId, iSolutionIdStatus_, iControlId, Val)
end

function _msp_getintattribprobextreme(msp, prob_to_rank_against, bGet_Max_Otherwise_Min, iSolutionId, iAttribId, ExtremeVal)
    @checked Lib.XPRS_msp_getintattribprobextreme(msp, prob_to_rank_against, bGet_Max_Otherwise_Min, iSolutionId, iAttribId, ExtremeVal)
end

function _msp_getdblattribprobextreme(msp, prob_to_rank_against, bGet_Max_Otherwise_Min, iSolutionId, iAttribId, ExtremeVal)
    @checked Lib.XPRS_msp_getdblattribprobextreme(msp, prob_to_rank_against, bGet_Max_Otherwise_Min, iSolutionId, iAttribId, ExtremeVal)
end

function _msp_getintattrib(msp, iAttribId, Val)
    @checked Lib.XPRS_msp_getintattrib(msp, iAttribId, Val)
end

function _msp_getdblattrib(msp, iAttribId, Val)
    @checked Lib.XPRS_msp_getdblattrib(msp, iAttribId, Val)
end

function _msp_getintcontrol(msp, iControlId, Val)
    @checked Lib.XPRS_msp_getintcontrol(msp, iControlId, Val)
end

function _msp_getdblcontrol(msp, iControlId, Val)
    @checked Lib.XPRS_msp_getdblcontrol(msp, iControlId, Val)
end

function _msp_setintcontrol(msp, iControlId, Val)
    @checked Lib.XPRS_msp_setintcontrol(msp, iControlId, Val)
end

function _msp_setdblcontrol(msp, iControlId, Val)
    @checked Lib.XPRS_msp_setdblcontrol(msp, iControlId, Val)
end

function _msp_setsolname(msp, iSolutionId, sNewSolutionBaseName, bNameModifiedForUniqueness, iSolutionIdStatus_)
    @checked Lib.XPRS_msp_setsolname(msp, iSolutionId, sNewSolutionBaseName, bNameModifiedForUniqueness, iSolutionIdStatus_)
end

function _msp_getsolname(msp, iSolutionId, _sname, _iStringBufferBytes, _iBytesInInternalString, iSolutionIdStatus_)
    @checked Lib.XPRS_msp_getsolname(msp, iSolutionId, _sname, _iStringBufferBytes, _iBytesInInternalString, iSolutionIdStatus_)
end

function _msp_findsolbyname(msp, sSolutionName, iSolutionId)
    @checked Lib.XPRS_msp_findsolbyname(msp, sSolutionName, iSolutionId)
end

function _msp_writeslxsol(msp, prob_context, iSolutionId, iSolutionIdStatus_, sFileName, sFlags)
    @checked Lib.XPRS_msp_writeslxsol(msp, prob_context, iSolutionId, iSolutionIdStatus_, sFileName, sFlags)
end

function _msp_readslxsol(msp, col_name_list, sFileName, sFlags, iSolutionId_Beg, iSolutionId_End)
    @checked Lib.XPRS_msp_readslxsol(msp, col_name_list, sFileName, sFlags, iSolutionId_Beg, iSolutionId_End)
end

function _msp_getlasterror(msp, iMsgCode, _msg, _iStringBufferBytes, _iBytesInInternalString)
    @checked Lib.XPRS_msp_getlasterror(msp, iMsgCode, _msg, _iStringBufferBytes, _iBytesInInternalString)
end

function _msp_setcbmsghandler(msp, f_msghandler, p)
    @checked Lib.XPRS_msp_setcbmsghandler(msp, f_msghandler, p)
end

function _msp_getcbmsghandler(msp, f_msghandler, p)
    @checked Lib.XPRS_msp_getcbmsghandler(msp, f_msghandler, p)
end

function _msp_addcbmsghandler(msp, f_msghandler, p, priority)
    @checked Lib.XPRS_msp_addcbmsghandler(msp, f_msghandler, p, priority)
end

function _msp_removecbmsghandler(msp, f_msghandler, p)
    @checked Lib.XPRS_msp_removecbmsghandler(msp, f_msghandler, p)
end

"""

    _nml_create(r_nl)

*Purpose*

The
XPRS_nml_* functions provide a simple, generic interface to lists of names, which may be names of rows/columns on a problem or may be a list of arbitrary names provided by the user.
XPRS_nml_create will create a new namelist to which the user can add, remove and otherwise modify names.

*Synopsis*

int XPRS_CC XPRS_nml_create(XPRSnamelist* p_nml);

*Arguments*

`p_nml`: Pointer to location where the new namelist will be returned.

*Example*

XPRSnamelist mylist;
XPRS_nml_create(&mylist);

*Related*

XPRSgetnamelistobject,
XPRS_nml_destroy.
"""
function _nml_create(r_nl)
    @checked Lib.XPRS_nml_create(r_nl)
end

"""

    _nml_destroy(nml)

*Purpose*

Destroys a namelist and frees any memory associated with it. Note you need only destroy namelists created by
XPRS_nml_destroy - those returned by
XPRSgetnamelistobject are automatically destroyed when you destroy the problem object.

*Synopsis*

int XPRS_CC XPRS_nml_destroy(XPRSnamelist nml);

*Arguments*

`nml`: The namelist to be destroyed.

*Example*

XPRSnamelist mylist;
XPRS_nml_create(&mylist);
...
XPRS_nml_destroy(&mylist);

*Related*

XPRS_nml_create,
XPRSgetnamelistobject,
XPRSdestroyprob.
"""
function _nml_destroy(nml)
    @checked Lib.XPRS_nml_destroy(nml)
end

"""

    _nml_getnamecount(nml, count)

*Purpose*

The
XPRS_nml_* functions provide a simple, generic interface to lists of names, which may be names of rows/columns on a problem or may be a list of arbitrary names provided by the user.
XPRS_nlm_getnamecount returns the number of names in the namelist.

*Synopsis*

int XPRS_CC XPRS_nml_getnamecount(XPRSnamelist nml, int* count);

*Arguments*

`nml`: The namelist object.
`count`: Pointer to a variable into which shall be written the number of names.

*Example*

XPRSnamelist mylist;
int count;
...
XPRS_nml_getnamecount(mylist,&count);
printf("There are %d names", count);

*Related*

None.
"""
function _nml_getnamecount(nml, count)
    @checked Lib.XPRS_nml_getnamecount(nml, count)
end

"""

    _nml_getmaxnamelen(nml, namlen)

*Purpose*

The
XPRS_nml_* functions provide a simple, generic interface to lists of names, which may be names of rows/columns on a problem or may be a list of arbitrary names provided by the user.
XPRS_nml_getmaxnamelen returns the length of the longest name in the namelist.

*Synopsis*

int XPRS_CC XPRS_nml_getmaxnamelen(XPRSnamelist nml, int* namlen);

*Arguments*

`nml`: The namelist object.
`namelen`: Pointer to a variable into which shall be written the length of the longest name.

*Example*



*Related*

None.
"""
function _nml_getmaxnamelen(nml, namlen)
    @checked Lib.XPRS_nml_getmaxnamelen(nml, namlen)
end

"""

    _nml_getnames(nml, padlen, buf, buflen, r_buflen_reqd, firstIndex, lastIndex)

*Purpose*

The
XPRS_nml_* functions provide a simple, generic interface to lists of names, which may be names of rows/columns on a problem or may be a list of arbitrary names provided by the user. The
XPRS_nml_getnames function returns some of the names held in the name list. The names shall be returned in a character buffer, and with each name being separated by a
NULL character.

*Synopsis*

int XPRS_CC XPRS_nml_getnames(XPRSnamelist nml, int padlen, char buf[], int buflen, int* r_buflen_reqd, int firstIndex, int lastIndex);

*Arguments*

`nml`: The namelist object.
`padlen`: The minimum length of each name. If
`>0 then names shorter than`: padlen will be concatenated with whitespace to make them this length.
`buf`: Buffer of length
`buflen into which the names shall be returned.`: buflen
`The maximum number of bytes that may be written to the character buffer`: buf.
`r_buflen_reqd`: A pointer to a variable into which will be written the number of bytes required to contain the names. May be NULL if not required.
`firstIndex`: The index of the first name in the namelist to return. Note name list indexes always start from 0.
`lastIndex`: The index of the last name in the namelist to return.

*Example*

XPRSnamelist mylist;
char* cbuf;
int o, i, cbuflen;
...
/* Find out how much space we'll require for these names */
XPRS_nml_getnames(mylist, 0, NULL, 0, &cbuflen, 0, 5 );
/* Allocate a buffer large enough to hold the names */
cbuf = malloc(cbuflen);
/* Retrieve the names */
XPRS_nml_getnames(mylist, 0, cbuf, cbuflen, NULL, 0, 5);
/* Display the names */
o=0;
for (i=0;i<6;i++) {
printf("Name #%d = %s\n", i, cbuf+o);
o += strlen(cbuf)+1;
}

*Related*

None.
"""
function _nml_getnames(nml, padlen, buf, buflen, r_buflen_reqd, firstIndex, lastIndex)
    @checked Lib.XPRS_nml_getnames(nml, padlen, buf, buflen, r_buflen_reqd, firstIndex, lastIndex)
end

"""

    _nml_addnames(nml, buf, firstIndex, lastIndex)

*Purpose*

The
XPRS_nml_* functions provide a simple, generic interface to lists of names, which may be names of rows/columns on a problem or may be a list of arbitrary names provided by the user. Use the
XPRS_nml_addnames to add names to a name list, or modify existing names on a namelist.

*Synopsis*

int XPRS_CC XPRS_nml_addnames(XPRSnamelist nml, const char buf[], int firstIndex, int lastIndex);

*Arguments*

`nml`: The name list to which you want to add names. Must be an object previously returned by
`XPRS_nml_create, as`: XPRSnamelist objects returned by other functions are immutable and cannot be changed.
`names`: Character buffer containing the null-terminated string names.
`first`: The index of the first name to add/replace. Name indices in a namelist always start from 0.
`last`: The index of the last name to add/replace.

*Example*

char mynames[0] = "fred\0jim\0sheila"
...
XPRS_nml_addnames(nml,mynames,0,2);

*Related*

XPRS_nml_create,
XPRS_nml_removenames,
XPRS_nml_copynames,
XPRSaddnames.
"""
function _nml_addnames(nml, buf, firstIndex, lastIndex)
    @checked Lib.XPRS_nml_addnames(nml, buf, firstIndex, lastIndex)
end

"""

    _nml_removenames(nml, firstIndex, lastIndex)

*Purpose*

The
XPRS_nml_* functions provide a simple, generic interface to lists of names, which may be names of rows/columns on a problem or may be a list of arbitrary names provided by the user.
XPRS_nml_removenames will remove the specified names from the name list. Any subsequent names will be moved down to replace the removed names.

*Synopsis*

int XPRS_CC XPRS_nml_removenames(XPRSnamelist nml, int firstIndex, int lastIndex);

*Arguments*

`nml`: The name list from which you want to remove names. Must be an object previously returned by
`XPRS_nml_create, as`: XPRSnamelist objects returned by other functions are immutable and cannot be changed.
`firstIndex`: The index of the first name to remove. Note that indices for names in a name list always start from 0.
`lastIndex`: The index of the last name to remove.

*Example*

XPRS_nml_removenames(mylist, 3, 5);

*Related*

XPRS_nml_addnames.
"""
function _nml_removenames(nml, firstIndex, lastIndex)
    @checked Lib.XPRS_nml_removenames(nml, firstIndex, lastIndex)
end

"""

    _nml_findname(nml, name, r_index)

*Purpose*

The
XPRS_nml_* functions provide a simple, generic interface to lists of names, which may be names of rows/columns on a problem or may be a list of arbitrary names provided by the user.
XPRS_nml_findname returns the index of the given name in the given name list.

*Synopsis*

int XPRS_CC XPRS_nml_findname(XPRSnamelist nml, const char* name, int* r_index);

*Arguments*

`nml`: The namelist in which to look for the name.
`name`: Null-terminated string containing the name for which to search.
`r_index`: Pointer to variable in which the index of the name is returned, or in which is returned -1 if the name is not found in the namelist.

*Example*

XPRSnamelist mylist;
int idx;
...
XPRS_nml_findname(mylist, "profit_after_work", &idx);
if (idx==-1)
printf("'profit_after_work' was not found in the namelist");
else
printf("'profit_after_work' was found at position %d", idx);

*Related*

XPRS_nml_addnames,
XPRS_nml_getnames.
"""
function _nml_findname(nml, name, r_index)
    @checked Lib.XPRS_nml_findname(nml, name, r_index)
end

"""

    _nml_copynames(dst, src)

*Purpose*

The
XPRS_nml_* functions provide a simple, generic interface to lists of names, which may be names of rows/columns on a problem or may be a list of arbitrary names provided by the user.
XPRS_nml_copynames allows you to copy all the names from one name list to another. As name lists representing row/column names cannot be modified,
XPRS_nml_copynames will be most often used to copy such names to a namelist where they can be modified, for some later use.

*Synopsis*

int XPRS_CC XPRS_nml_copynames(XPRSnamelist dst, XPRSnamelist src);

*Arguments*

`dst`: The namelist object to copy names to. Any names already in this name list will be removed. Must be an object previously returned by
`XPRS_nml_create.`: src

*Example*

XPRSprob prob;
XPRSnamelist rnames, rnames_on_prob;
...
/* Create a namelist */
XPRS_nml_create(&rnames);
/* Get a namelist through which we can access the row names */
XPRSgetnamelistobject(prob,1,&rnames_on_prob);
/* Now copy these names from the immutable 'XPRSprob' namelist
to another one */
XPRS_nml_copynames(rnames,rnames_on_prob);
/* The names in the list can now be modified then put to some
other use */

*Related*

XPRS_nml_create,
XPRS_nml_addnames,
XPRSgetnamelistobject.
"""
function _nml_copynames(dst, src)
    @checked Lib.XPRS_nml_copynames(dst, src)
end

"""

    _nml_getlasterror(nml, iMsgCode, _msg, _iStringBufferBytes, _iBytesInInternalString)

*Purpose*

Returns the last error encountered during a call to a namelist object.

*Synopsis*

int XPRS_CC XPRS_nml_getlasterror(XPRSnamelist nml, int* iMsgCode, char* _msg, int _iStringBufferBytes, int* _iBytesInInternalString);

*Arguments*

`nml`: The namelist object.
`iMsgCode`: Variable in which the error code will be returned. Can be NULL if not required.
`_msg`: A character buffer of size
`iStringBufferBytes in which the last error message relating to this namelist will be returned.`: _iStringBufferBytes
`The size of the character buffer`: _msg.
`_iBytesInInternalString`: Memory location in which the minimum required size of the buffer to hold the full error string will be returned. Can be NULL if not required.

*Example*

XPRSnamelist nml;
char* cbuf;
int cbuflen;
...
if (XPRS_nml_removenames(nml,2,35)) {
XPRS_nml_getlasterror(nml, NULL, NULL, 0, &cbuflen);
cbuf = malloc(cbuflen);
XPRS_nml_getlasterror(nml, NULL, cbuf, cbuflen, NULL);
printf("ERROR removing names: %s\n", cbuf);
}

*Related*

None.
"""
function _nml_getlasterror(nml, iMsgCode, _msg, _iStringBufferBytes, _iBytesInInternalString)
    @checked Lib.XPRS_nml_getlasterror(nml, iMsgCode, _msg, _iStringBufferBytes, _iBytesInInternalString)
end

"""

    getqrowcoeff(prob::XpressProblem, irow, icol, jcol, dval)

*Purpose*

Returns a single quadratic constraint coefficient corresponding to the variable pair (
icol,
jcol) of the Hessian of a given constraint.

*Synopsis*

int XPRS_CC XPRSgetqrowcoeff (XPRSprob prob, int row, int icol, int jcol, double *dval);

*Arguments*

`prob`: The current problem.
`row`: The quadratic row where the coefficient is to be looked up.
`icol`: Column index for the first variable in the quadratic term.
`jcol`: Column index for the second variable in the quadratic term.
`dval`: Pointer to a double value where the objective function coefficient is to be placed.

*Example*

The following returns the coefficient of the
x02 term in the second row, placing it in the variable value :

*Related*

XPRSloadqcqp,
XPRSaddqmatrix,
XPRSchgqrowcoeff,
XPRSgetqrowqmatrix,
XPRSgetqrowqmatrixtriplets,
XPRSgetqrows,
XPRSchgqobj,
XPRSchgmqobj,
XPRSgetqobj.
"""
function getqrowcoeff(prob::XpressProblem, irow, icol, jcol, dval)
    @checked Lib.XPRSgetqrowcoeff(prob, irow, icol, jcol, dval)
end

"""

    getqrowqmatrix(prob::XpressProblem, irow, mstart, mclind, dobjval, maxcoeffs, ncoeffs, first, last)

*Purpose*

Returns the nonzeros in a quadratic constraint coefficients matrix for the columns in a given range. To achieve maximum efficiency,
XPRSgetqrowqmatrix returns the lower triangular part of this matrix only.

*Synopsis*

int XPRS_CC XPRSgetqrowqmatrix(XPRSprob prob, int irow, int mstart[], int mclind[], double dqe[], int size, int * nels, int first, int last);

*Arguments*

`prob`: The current problem.
`irow`: Index of the row for which the quadratic coefficients are to be returned.
`mstart`: Integer array which will be filled with indices indicating the starting offsets in the
`mclind and`: dobjval arrays for each requested column. It must be length of at least
`last-first+2. Column`: i starts at position
`mstart[i] in the`: mrwind and
`dmatval arrays, and has`: mstart[i+1]-mstart[i] elements in it. May be NULL if size is 0.
`mclind`: Integer array of length size which will be filled with the column indices of the nonzero elements in the lower triangular part of Q. May be NULL if size is 0.
`dqe`: Double array of length size which will be filled with the nonzero element values. May be NULL if size is 0.
`size`: Number of elements to be saved in mclind and dqe. If
`size < *nels, only`: size elements are written.
`nels`: Pointer to the integer where the number of nonzero elements in the
`mclind and`: dobjval arrays will be returned. If the number of nonzero elements is greater than size, then only size elements will be returned. If
`nels is smaller than size, then only`: nels will be returned.
`first`: First column in the range.
`last`: Last column in the range.

*Example*



*Related*

XPRSloadqcqp,
XPRSgetqrowcoeff,
XPRSaddqmatrix,
XPRSchgqrowcoeff,
XPRSgetqrowqmatrixtriplets,
XPRSgetqrows,
XPRSchgqobj,
XPRSchgmqobj,
XPRSgetqobj.
"""
function getqrowqmatrix(prob::XpressProblem, irow, mstart, mclind, dobjval, maxcoeffs, ncoeffs, first::Integer, last::Integer)
    @checked Lib.XPRSgetqrowqmatrix(prob, irow, mstart, mclind, dobjval, maxcoeffs, ncoeffs, first, last)
end

"""

    getqrowqmatrixtriplets(prob::XpressProblem, irow, nqelem, mqcol1, mqcol2, dqe)

*Purpose*

Returns the nonzeros in a quadratic constraint coefficients matrix as triplets (index pairs with coefficients). To achieve maximum efficiency,
XPRSgetqrowqmatrixtriplets returns the lower triangular part of this matrix only.

*Synopsis*

int XPRS_CC XPRSgetqrowqmatrixtriplets(XPRSprob prob, int irow, int * nqelem, int mqcol1[], int mqcol2[], double dqe[]);

*Arguments*

`prob`: The current problem.
`irow`: Index of the row for which the quadratic coefficients are to be returned.
`nqelem`: Argument used to return the number of quadratic coefficients in the row.
`mqcol1`: First index in the triplets. May be NULL if not required.
`mqcol2`: Second index in the triplets. May be NULL if not required.
`dqe`: Coefficients in the triplets. May be NULL if not required.

*Example*



*Related*

XPRSloadqcqp,
XPRSgetqrowcoeff,
XPRSaddqmatrix,
XPRSchgqrowcoeff,
XPRSgetqrowqmatrix,
XPRSgetqrows,
XPRSchgqobj,
XPRSchgmqobj,
XPRSgetqobj.
"""
function getqrowqmatrixtriplets(prob::XpressProblem, irow, nqelem, mqcol1, mqcol2, dqe)
    @checked Lib.XPRSgetqrowqmatrixtriplets(prob, irow, nqelem, mqcol1, mqcol2, dqe)
end

"""

    chgqrowcoeff(prob::XpressProblem, irow, icol, jcol, dval)

*Purpose*

Changes a single quadratic coefficient in a row.

*Synopsis*

int XPRS_CC XPRSchgqrowcoeff(XPRSprob prob, int irow, int icol, int jcol, double dval);

*Arguments*

`prob`: The current problem.
`irow`: Index of the row where the quadratic matrix is to be changed.
`icol`: First index of the coefficient to be changed.
`jcol`: Second index of the coefficient to be changed.
`dval`: The new coefficient.

*Example*



*Related*

XPRSloadqcqp,
XPRSgetqrowcoeff,
XPRSaddqmatrix,
XPRSchgqrowcoeff,
XPRSgetqrowqmatrix,
XPRSgetqrowqmatrixtriplets,
XPRSgetqrows,
XPRSchgqobj,
XPRSchgmqobj,
XPRSgetqobj.
"""
function chgqrowcoeff(prob::XpressProblem, irow, icol, jcol, dval)
    @checked Lib.XPRSchgqrowcoeff(prob, irow, icol, jcol, dval)
end

"""

    getqrows(prob::XpressProblem, qmn, qcrows)

*Purpose*

Returns the list indices of the rows that have quadratic coefficients.

*Synopsis*

int XPRS_CC XPRSgetqrows(XPRSprob prob, int * qmn, int qcrows[]);

*Arguments*

`prob`: The current problem.
`qmn`: Used to return the number of quadratic constraints in the matrix.
`qcrows`: Array of length

*Example*



*Related*

XPRSloadqcqp,
XPRSgetqrowcoeff,
XPRSaddqmatrix,
XPRSchgqrowcoeff,
XPRSgetqrowqmatrix,
XPRSgetqrowqmatrixtriplets,
XPRSchgqobj,
XPRSchgmqobj,
XPRSgetqobj.
"""
function getqrows(prob::XpressProblem, qmn, qcrows)
    @checked Lib.XPRSgetqrows(prob, qmn, qcrows)
end

"""

    addqmatrix(prob::XpressProblem, irow, nqtr, mqc1, mqc2, dqew)

*Purpose*

Adds a new quadratic matrix into a row defined by triplets.

*Synopsis*

int XPRS_CC XPRSaddqmatrix(XPRSprob prob, int irow, int nqtr, const int mqc1[], const int mqc2[], const double dqe[]);

*Arguments*

`prob`: The current problem.
`irow`: Index of the row where the quadratic matrix is to be added.
`nqtr`: Number of triplets used to define the quadratic matrix. This may be less than the number of coefficients in the quadratic matrix, since off diagonals and their transposed pairs are defined by one triplet.
`mqc1`: First index in the triplets.
`mqc2`: Second index in the triplets.
`dqe`: Coefficients in the triplets.

*Example*



*Related*

XPRSloadqcqp,
XPRSgetqrowcoeff,
XPRSchgqrowcoeff,
XPRSgetqrowqmatrix,
XPRSgetqrowqmatrixtriplets,
XPRSgetqrows,
XPRSchgqobj,
XPRSchgmqobj,
XPRSgetqobj.
"""
function addqmatrix(prob::XpressProblem, irow, nqtr, mqc1, mqc2, dqew)
    @checked Lib.XPRSaddqmatrix(prob, irow, nqtr, mqc1, mqc2, dqew)
end

function addqmatrix64(prob::XpressProblem, irow, nqtr, mqc1, mqc2, dqew)
    @checked Lib.XPRSaddqmatrix64(prob, irow, nqtr, mqc1, mqc2, dqew)
end

"""

    delqmatrix(prob::XpressProblem, irow)

*Purpose*

Deletes the quadratic part of a row or of the objective function.

*Synopsis*

int XPRS_CC XPRSdelqmatrix(XPRSprob prob, int row);

*Arguments*

`prob`: The current problem.
`row`: Index of row from which the quadratic part is to be deleted.

*Example*



*Related*

XPRSaddrows,
XPRSdelcols,
XPRSdelrows.
"""
function delqmatrix(prob::XpressProblem, irow)
    @checked Lib.XPRSdelqmatrix(prob, irow)
end

"""

    loadqcqp(prob::XpressProblem, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub, nquads, _mqcol1, _mqcol2, _dqval, qmn, qcrows, qcnquads, qcmqcol1, qcmqcol2, qcdqval)

*Purpose*

Used to load a quadratic problem with quadratic side constraints into the Optimizer data structure. Such a problem may have quadratic terms in its objective function as well as in its constraints.

*Synopsis*

int XPRS_CC XPRSloadqcqp(XPRSprob prob, const char * probname, int ncol, int nrow, const char qrtypes[], const double rhs[], const double range[], const double obj[], const int mstart[], const int mnel[], const int mrwind[], const double dmatval[], const double dlb[], const double dub[], int nqtr, const int mqcol1[], const int mqcol2[], const double dqe[], int qmn, const int qcrows[], const int qcnquads[], const int qcmqcol1[], const int qcmqcol2[], const double qcdqval[]);

*Arguments*

`prob`: The current problem.
`probname`: A string of up to
`MAXPROBNAMELENGTH characters containing a name for the problem.`: ncol
`Number of structural columns in the matrix.`: nrow
`Number of rows in the matrix (not including the objective row). Objective coefficients must be supplied in the`: obj array, and the objective function should not be included in any of the other arrays.
`qrtype`: Character array of length
`nrow containing the row types:`: L
`indicates a`: <= constraint (use this one for quadratic constraints as well);
`E`: indicates an
`= constraint;`: G
`indicates a`: >= constraint;
`R`: indicates a range constraint;
`N`: indicates a nonbinding constraint.
`rhs`: Double array of length
`nrow containing the right hand side coefficients of the rows. The right hand side value for a range row gives the`: upper bound on the row.
`range`: Double array of length
`nrow containing the range values for range rows. Values for all other rows will be ignored. May be NULL if there are no ranged constraints. The lower bound on a range row is the right hand side value minus the range value. The sign of the range value is ignored - the absolute value is used in all cases.`: obj
`Double array of length`: ncol containing the objective function coefficients.
`mstart`: Integer array containing the offsets in the
`mrwind and`: dmatval arrays of the start of the elements for each column. This array is of length
`ncol or, if`: mnel is NULL,
`length ncol+1. If`: mnel is NULL the extra entry of
`mstart,`: mstart[ncol], contains the position in the
`mrwind and`: dmatval arrays at which an extra column would start, if it were present. In C, this value is also the length of the
`mrwind and`: dmatval arrays.
`mnel`: Integer array of length
`ncol containing the number of nonzero elements in each column. May be NULL if all elements are contiguous and`: mstart[ncol] contains the offset where the elements for column
`ncol+1 would start. This array is not required if the non-zero coefficients in the`: mrwind and
`dmatval arrays are continuous, and the`: mstart array has
`ncol+1 entries as described above. It may be NULL if not required.`: mrwind
`Integer array containing the row indices for the nonzero elements in each column. If the indices are input contiguously, with the columns in ascending order, the length of the`: mrwind is
`mstart[ncol-1]+mnel[ncol-1] or, if`: mnel is NULL,
`mstart[ncol].`: dmatval
`Double array containing the nonzero element values; length as for`: mrwind.
`dlb`: Double array of length
`ncol containing the lower bounds on the columns. Use`: XPRS_MINUSINFINITY to represent a lower bound of minus infinity.
`dub`: Double array of length
`ncol containing the upper bounds on the columns. Use`: XPRS_PLUSINFINITY to represent an upper bound of plus infinity.
`nqtr`: Number of quadratic terms.
`mqc1`: Integer array of size
`nqtr containing the column index of the first variable in each quadratic term.`: mqc2
`Integer array of size`: nqtr containing the column index of the second variable in each quadratic term.
`dqe`: Double array of size
`nqtr containing the quadratic coefficients.`: qmn
`Number of rows containing quadratic matrices.`: qcrows
`Integer array of size`: qmn, containing the indices of rows with quadratic matrices in them. Note that the rows are expected to be defined in
`qrtype as type`: L.
`qcnquads`: Integer array of size
`qmn, containing the number of nonzeros in each quadratic constraint matrix.`: qcmqcol1
`Integer array of size`: nqcelem, where
`nqcelem equals the sum of the elements in`: qcnquads (i.e. the total number of quadratic matrix elements in all the constraints). It contains the first column indices of the quadratic matrices. Indices for the first matrix are listed from
`0 to`: qcnquads[0]-1, for the second matrix from
`qcnquads[0] to`: qcnquads[0]+ qcnquads[1]-1, etc.
`qcmqcol2`: Integer array of size
`nqcelem, containing the second index for the quadratic constraint matrices.`: qcdqval
`Integer array of size`: nqcelem, containing the coefficients for the quadratic constraint matrices.

*Example*

To load the following problem presented in LP format:

*Related*

XPRSloadglobal,
XPRSloadlp,
XPRSloadqglobal,
XPRSloadqp,
XPRSreadprob.
"""
function loadqcqp(prob::XpressProblem, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub, nquads, _mqcol1, _mqcol2, _dqval, qmn, qcrows, qcnquads, qcmqcol1, qcmqcol2, qcdqval)
    @checked Lib.XPRSloadqcqp(prob, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub, nquads, _mqcol1, _mqcol2, _dqval, qmn, qcrows, qcnquads, qcmqcol1, qcmqcol2, qcdqval)
end

function loadqcqp64(prob::XpressProblem, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub, nquads, _mqcol1, _mqcol2, _dqval, qmn, qcrows, qcnquads, qcmqcol1, qcmqcol2, qcdqval)
    @checked Lib.XPRSloadqcqp64(prob, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub, nquads, _mqcol1, _mqcol2, _dqval, qmn, qcrows, qcnquads, qcmqcol1, qcmqcol2, qcdqval)
end

"""

    loadqcqpglobal(prob::XpressProblem, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _matbeg, _matcnt, _matrow, _dmatval, _dlb, _dub, nquads, _mqcol1, _mqcol2, _dqval, qmn, qcrows, qcnquads, qcmqcol1, qcmqcol2, qcdqval, ngents, nsets, qgtype, mgcols, dlim, qstype, msstart, mscols, dref)

*Purpose*

Used to load a global, quadratic problem with quadratic side constraints into the Optimizer data structure. Such a problem may have quadratic terms in its objective function as well as in its constraints. Integer, binary, partial integer, semi-continuous and semi-continuous integer variables can be defined, together with sets of type 1 and 2. The reference row values for the set members are passed as an array rather than specifying a reference row.

*Synopsis*

int XPRS_CC XPRSloadqcqpglobal(XPRSprob prob, const char * probname, int ncol, int nrow, const char qrtypes[], const double rhs[], const double range[], const double obj[], const int mstart[], const int mnel[], const int mrwind[], const double dmatval[], const double dlb[], const double dub[], int nqtr, const int mqcol1[], const int mqcol2[], const double dqe[], int qmn, const int qcrows[], const int qcnquads[], const int qcmqcol1[], const int qcmqcol2[], const double qcdqval[], const int ngents, const int nsets, const char qgtype[], const int mgcols[], const double dlim[], const char qstype[], const int msstart[], const int mscols[], const double dref[]);

*Arguments*

`prob`: The current problem.
`probname`: A string of up to
`MAXPROBNAMELENGTH characters containing a name for the problem.`: ncol
`Number of structural columns in the matrix.`: nrow
`Number of rows in the matrix (not including the objective row). Objective coefficients must be supplied in the`: obj array, and the objective function should not be included in any of the other arrays.
`qrtype`: Character array of length
`nrow containing the row types:`: L
`indicates a`: <= constraint (use this one for quadratic constraints as well);
`E`: indicates an
`= constraint;`: G
`indicates a`: >= constraint;
`R`: indicates a range constraint;
`N`: indicates a nonbinding constraint.
`rhs`: Double array of length
`nrow containing the right hand side coefficients of the rows. The right hand side value for a range row gives the`: upper bound on the row.
`range`: Double array of length
`nrow containing the range values for range rows. Values for all other rows will be ignored. May be NULL if there are no ranged constraints. The lower bound on a range row is the right hand side value minus the range value. The sign of the range value is ignored - the absolute value is used in all cases.`: obj
`Double array of length`: ncol containing the objective function coefficients.
`mstart`: Integer array containing the offsets in the
`mrwind and`: dmatval arrays of the start of the elements for each column. This array is of length
`ncol or, if`: mnel is NULL,
`length ncol+1. If`: mnel is NULL the extra entry of
`mstart,`: mstart[ncol], contains the position in the
`mrwind and`: dmatval arrays at which an extra column would start, if it were present. In C, this value is also the length of the
`mrwind and`: dmatval arrays.
`mnel`: Integer array of length
`ncol containing the number of nonzero elements in each column. May be NULL if all elements are contiguous and`: mstart[ncol] contains the offset where the elements for column
`ncol+1 would start. This array is not required if the non-zero coefficients in the`: mrwind and
`dmatval arrays are continuous, and the`: mstart array has
`ncol+1 entries as described above. It may be NULL if not required.`: mrwind
`Integer array containing the row indices for the nonzero elements in each column. If the indices are input contiguously, with the columns in ascending order, the length of the`: mrwind is
`mstart[ncol-1]+mnel[ncol-1] or, if`: mnel is NULL,
`mstart[ncol].`: dmatval
`Double array containing the nonzero element values; length as for`: mrwind.
`dlb`: Double array of length
`ncol containing the lower bounds on the columns. Use`: XPRS_MINUSINFINITY to represent a lower bound of minus infinity.
`dub`: Double array of length
`ncol containing the upper bounds on the columns. Use`: XPRS_PLUSINFINITY to represent an upper bound of plus infinity.
`nqtr`: Number of quadratic terms.
`mqc1`: Integer array of size
`nqtr containing the column index of the first variable in each quadratic term.`: mqc2
`Integer array of size`: nqtr containing the column index of the second variable in each quadratic term.
`dqe`: Double array of size
`nqtr containing the quadratic coefficients.`: qmn
`Number of rows containing quadratic matrices.`: qcrows
`Integer array of size`: qmn, containing the indices of rows with quadratic matrices in them. Note that the rows are expected to be defined in
`qrtype as type`: L.
`qcnquads`: Integer array of size
`qmn, containing the number of nonzeros in each quadratic constraint matrix.`: qcmqcol1
`Integer array of size`: nqcelem, where
`nqcelem equals the sum of the elements in`: qcnquads (i.e. the total number of quadratic matrix elements in all the constraints). It contains the first column indices of the quadratic matrices. Indices for the first matrix are listed from
`0 to`: qcnquads[0]-1, for the second matrix from
`qcnquads[0] to`: qcnquads[0]+ qcnquads[1]-1, etc.
`qcmqcol2`: Integer array of size
`nqcelem, containing the second index for the quadratic constraint matrices.`: qcdqval
`Integer array of size`: nqcelem, containing the coefficients for the quadratic constraint matrices.
`ngents`: Number of binary, integer, semi-continuous, semi-continuous integer and partial integer entities.
`nsets`: Number of SOS1 and SOS2 sets.
`qgtype`: Character array of length
`ngents containing the entity types:`: B
`binary variables;`: I
`integer variables;`: P
`partial integer variables;`: S
`semi-continuous variables;`: R
`semi-continuous integer variables.`: mgcols
`Integer array of length`: ngents containing the column indices of the global entities.
`dlim`: Double array of length
`ngents containing the integer limits for the partial integer variables and lower bounds for semi-continuous and semi-continuous integer variables (any entries in the positions corresponding to binary and integer variables will be ignored). May be`: NULL if not required.
`qstype`: Character array of length
`nsets containing the set types:`: 1
`SOS1 type sets;`: 2
`SOS2 type sets.`: May be
`NULL if not required.`: msstart
`Integer array containing the offsets in the`: mscols and
`dref arrays indicating the start of the sets. This array is of length`: nsets+1, the last member containing the offset where set
`nsets+1 would start. May be`: NULL if not required.
`mscols`: Integer array of length
`msstart[nsets]-1 containing the columns in each set. May be`: NULL if not required.
`dref`: Double array of length
`msstart[nsets]-1 containing the reference row entries for each member of the sets. May be`: NULL if not required.

*Example*



*Related*

XPRSloadglobal,
XPRSloadlp,
XPRSloadqcqp,
XPRSloadqglobal,
XPRSloadqp,
XPRSreadprob.
"""
function loadqcqpglobal(prob::XpressProblem, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _matbeg, _matcnt, _matrow, _dmatval, _dlb, _dub, nquads, _mqcol1, _mqcol2, _dqval, qmn, qcrows, qcnquads, qcmqcol1, qcmqcol2, qcdqval, ngents, nsets, qgtype, mgcols, dlim, qstype, msstart, mscols, dref)
    @checked Lib.XPRSloadqcqpglobal(prob, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _matbeg, _matcnt, _matrow, _dmatval, _dlb, _dub, nquads, _mqcol1, _mqcol2, _dqval, qmn, qcrows, qcnquads, qcmqcol1, qcmqcol2, qcdqval, ngents, nsets, qgtype, mgcols, dlim, qstype, msstart, mscols, dref)
end

function loadqcqpglobal64(prob::XpressProblem, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _matbeg, _matcnt, _matrow, _dmatval, _dlb, _dub, nquads, _mqcol1, _mqcol2, _dqval, qmn, qcrows, qcnquads, qcmqcol1, qcmqcol2, qcdqval, ngents, nsets, qgtype, mgcols, dlim, qstype, msstart, mscols, dref)
    @checked Lib.XPRSloadqcqpglobal64(prob, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _matbeg, _matcnt, _matrow, _dmatval, _dlb, _dub, nquads, _mqcol1, _mqcol2, _dqval, qmn, qcrows, qcnquads, qcmqcol1, qcmqcol2, qcdqval, ngents, nsets, qgtype, mgcols, dlim, qstype, msstart, mscols, dref)
end

function _mse_create(mse)
    @checked Lib.XPRS_mse_create(mse)
end

function _mse_destroy(mse)
    @checked Lib.XPRS_mse_destroy(mse)
end

function _mse_getsollist(mse, iMetricId, iRankFirstIndex_Ob, iRankLastIndex_Ob, iSolutionIds, nReturnedSolIds, nSols)
    @checked Lib.XPRS_mse_getsollist(mse, iMetricId, iRankFirstIndex_Ob, iRankLastIndex_Ob, iSolutionIds, nReturnedSolIds, nSols)
end

function _mse_getsolmetric(mse, iSolutionId, iSolutionIdStatus, iMetricId, dMetric)
    @checked Lib.XPRS_mse_getsolmetric(mse, iSolutionId, iSolutionIdStatus, iMetricId, dMetric)
end

function _mse_getcullchoice(mse, iMetricId, cull_sol_id_list, nMaxSolsToCull, nSolsToCull, dNewSolMetric, x, nCols, bRejectSoln)
    @checked Lib.XPRS_mse_getcullchoice(mse, iMetricId, cull_sol_id_list, nMaxSolsToCull, nSolsToCull, dNewSolMetric, x, nCols, bRejectSoln)
end

function _mse_minim(mse, prob::XpressProblem, msp, f_mse_handler, p, nMaxSols)
    @checked Lib.XPRS_mse_minim(mse, prob, msp, f_mse_handler, p, nMaxSols)
end

function _mse_maxim(mse, prob::XpressProblem, msp, f_mse_handler, p, nMaxSols)
    @checked Lib.XPRS_mse_maxim(mse, prob, msp, f_mse_handler, p, nMaxSols)
end

function _mse_opt(mse, prob::XpressProblem, msp, f_mse_handler, p, nMaxSols)
    @checked Lib.XPRS_mse_opt(mse, prob, msp, f_mse_handler, p, nMaxSols)
end

function _mse_getintattrib(mse, iAttribId, Val)
    @checked Lib.XPRS_mse_getintattrib(mse, iAttribId, Val)
end

function _mse_getdblattrib(mse, iAttribId, Val)
    @checked Lib.XPRS_mse_getdblattrib(mse, iAttribId, Val)
end

function _mse_getintcontrol(mse, iAttribId, Val)
    @checked Lib.XPRS_mse_getintcontrol(mse, iAttribId, Val)
end

function _mse_getdblcontrol(mse, iAttribId, Val)
    @checked Lib.XPRS_mse_getdblcontrol(mse, iAttribId, Val)
end

function _mse_setintcontrol(mse, iAttribId, Val)
    @checked Lib.XPRS_mse_setintcontrol(mse, iAttribId, Val)
end

function _mse_setdblcontrol(mse, iAttribId, Val)
    @checked Lib.XPRS_mse_setdblcontrol(mse, iAttribId, Val)
end

function _mse_getlasterror(mse, iMsgCode, _msg, _iStringBufferBytes, _iBytesInInternalString)
    @checked Lib.XPRS_mse_getlasterror(mse, iMsgCode, _msg, _iStringBufferBytes, _iBytesInInternalString)
end

function _mse_setsolbasename(mse, sSolutionBaseName)
    @checked Lib.XPRS_mse_setsolbasename(mse, sSolutionBaseName)
end

function _mse_getsolbasename(mse, _sname, _iStringBufferBytes, _iBytesInInternalString)
    @checked Lib.XPRS_mse_getsolbasename(mse, _sname, _iStringBufferBytes, _iBytesInInternalString)
end

function _mse_setcbgetsolutiondiff(mse, f_mse_getsolutiondiff, p)
    @checked Lib.XPRS_mse_setcbgetsolutiondiff(mse, f_mse_getsolutiondiff, p)
end

function _mse_getcbgetsolutiondiff(mse, f_mse_getsolutiondiff, p)
    @checked Lib.XPRS_mse_getcbgetsolutiondiff(mse, f_mse_getsolutiondiff, p)
end

function _mse_addcbgetsolutiondiff(mse, f_mse_getsolutiondiff, p, priority)
    @checked Lib.XPRS_mse_addcbgetsolutiondiff(mse, f_mse_getsolutiondiff, p, priority)
end

function _mse_removecbgetsolutiondiff(mse, f_mse_getsolutiondiff, p)
    @checked Lib.XPRS_mse_removecbgetsolutiondiff(mse, f_mse_getsolutiondiff, p)
end

function _mse_setcbmsghandler(mse, f_msghandler, p)
    @checked Lib.XPRS_mse_setcbmsghandler(mse, f_msghandler, p)
end

function _mse_getcbmsghandler(mse, f_msghandler, p)
    @checked Lib.XPRS_mse_getcbmsghandler(mse, f_msghandler, p)
end

function _mse_addcbmsghandler(mse, f_msghandler, p, priority)
    @checked Lib.XPRS_mse_addcbmsghandler(mse, f_msghandler, p, priority)
end

function _mse_removecbmsghandler(mse, f_msghandler, p)
    @checked Lib.XPRS_mse_removecbmsghandler(mse, f_msghandler, p)
end

"""

    _bo_create(p_object, prob::XpressProblem, isoriginal)

*Purpose*

Creates a new user defined branching object for the Optimizer to branch on. This function should be called only from within one of the callback functions set by
XPRSaddcboptnode or
XPRSaddcbchgbranchobject.

*Synopsis*

int XPRS_CC XPRS_bo_create(XPRSbranchobject* p_object, XPRSprob prob, int isoriginal);

*Arguments*

`p_object`: Pointer to where the new object should be returned.
`prob`: The problem structure that the branching object should be created for.
`isoriginal`: If the branching object will be set up for the original matrix, which determines how column indices are interpreted when adding bounds and rows to the object:
`0`: Column indices should refer to the current (presolved) node problem.
`1`: Column indices should refer to the original matrix.

*Example*

The following function will create a branching object equivalent to a standard binary branch on a column:

*Related*

XPRSaddcboptnode,
XPRSaddcbchgbranchobject.
"""
function _bo_create(p_object, prob::XpressProblem, isoriginal)
    @checked Lib.XPRS_bo_create(p_object, prob, isoriginal)
end

"""

    _bo_destroy(obranch)

*Purpose*

Frees all memory for a user branching object, when the object was not stored with the Optimizer.

*Synopsis*

int XPRS_CC XPRS_bo_destroy(XPRSbranchobject obranch);

*Arguments*

`obranch`: The user branching object to free.

*Example*



*Related*

XPRS_bo_create,
XPRS_bo_store.
"""
function _bo_destroy(obranch)
    @checked Lib.XPRS_bo_destroy(obranch)
end

"""

    _bo_store(obranch, p_status)

*Purpose*

Adds a new user branching object to the Optimizer's list of candidates for branching. This function is available only through the callback function set by
XPRSaddcboptnode.

*Synopsis*

int XPRS_CC XPRS_bo_store(XPRSbranchobject obranch, int* p_status);

*Arguments*

`obranch`: The new user branching object to store. After this call the
`obranch object is no longer valid and should not be referred to again.`: p_status
`The returned status from checking the provided branching object:`: 0
`The object was accepted successfully.`: 1
`Failed to presolve the object due to dual reductions in presolve.`: 2
`Failed to presolve the object due to duplicate column reductions in presolve.`: 3
`The object contains an empty branch.`: The object was not added to the candidate list if a non zero status is returned.

*Example*



*Related*

XPRS_bo_create,
XPRS_bo_validate.
"""
function _bo_store(obranch, p_status)
    @checked Lib.XPRS_bo_store(obranch, p_status)
end

"""

    _bo_addbranches(obranch, nbranches)

*Purpose*

Adds new, empty branches to a user defined branching object.

*Synopsis*

int XPRS_CC XPRS_bo_addbranches(XPRSbranchobject obranch, int nbranches);

*Arguments*

`obranch`: The user branching object to modify.
`nbranches`: Number of new branches to create.

*Example*

See
XPRS_bo_create for an example using
XPRS_bo_addbranches.

*Related*

XPRS_bo_create.
"""
function _bo_addbranches(obranch, nbranches)
    @checked Lib.XPRS_bo_addbranches(obranch, nbranches)
end

"""

    _bo_getbranches(obranch, p_nbranches)

*Purpose*

Returns the number of branches of a branching object.

*Synopsis*

int XPRS_CC XPRS_bo_getbranches(XPRSbranchobject obranch, int* p_nbranches);

*Arguments*

`obranch`: The user branching object to inspect.
`p_nbranches`: Memory where the number of branches should be returned.

*Example*



*Related*

XPRS_bo_create,
XPRS_bo_addbranches.
"""
function _bo_getbranches(obranch, p_nbranches)
    @checked Lib.XPRS_bo_getbranches(obranch, p_nbranches)
end

"""

    _bo_setpriority(obranch, ipriority)

*Purpose*

Sets the priority value of a user branching object.

*Synopsis*

int XPRS_CC XPRS_bo_setpriority(XPRSbranchobject obranch, int ipriority);

*Arguments*

`obranch`: The user branching object.
`ipriority`: The new priority value to assign to the branching object, which must be a number from 0 to 1000. User branching objects are created with a default priority value of 500.

*Example*



*Related*

XPRS_bo_create, Section
The Directives (.dir) File.
"""
function _bo_setpriority(obranch, ipriority)
    @checked Lib.XPRS_bo_setpriority(obranch, ipriority)
end

"""

    _bo_setpreferredbranch(obranch, ibranch)

*Purpose*

Specifies which of the child nodes corresponding to the branches of the object should be explored first.

*Synopsis*

int XPRS_CC XPRS_bo_setpreferredbranch(XPRSbranchobject obranch, int ibranch);

*Arguments*

`obranch`: The user branching object.
`ibranch`: The number of the branch to mark as preferred.

*Example*



*Related*

XPRS_bo_create.
"""
function _bo_setpreferredbranch(obranch, ibranch)
    @checked Lib.XPRS_bo_setpreferredbranch(obranch, ibranch)
end

"""

    _bo_addbounds(obranch, ibranch, nbounds, cbndtype, mbndcol, dbndval)

*Purpose*

Adds new bounds to a branch of a user branching object.

*Synopsis*

int XPRS_CC XPRS_bo_addbounds(XPRSbranchobject obranch, int ibranch, int nbounds, const char cbndtype[], const int mbndcol[], const double dbndval[]);

*Arguments*

`obranch`: The user branching object to modify.
`ibranch`: The number of the branch to add the new bounds for. This branch must already have been created using
`XPRS_bo_addbranches. Branches are indexed starting from zero.`: nbounds
`Number of new bounds to add.`: cbndtype
`Character array of length`: nbounds indicating the type of bounds to add:
`L`: Lower bound.
`U`: Upper bound.
`mbndcol`: Integer array of length
`nbounds containing the column indices for the new bounds.`: dbndval
`Double array of length`: nbounds giving the bound values.

*Example*

See
XPRS_bo_create for an example using
XPRS_bo_addbounds.

*Related*

XPRS_bo_create.
"""
function _bo_addbounds(obranch, ibranch, nbounds, cbndtype, mbndcol, dbndval)
    @checked Lib.XPRS_bo_addbounds(obranch, ibranch, nbounds, cbndtype, mbndcol, dbndval)
end

"""

    _bo_getbounds(obranch, ibranch, p_nbounds, nbounds_size, cbndtype, mbndcol, dbndval)

*Purpose*

Returns the bounds for a branch of a user branching object.

*Synopsis*

int XPRS_CC XPRS_bo_getbounds(XPRSbranchobject obranch, int ibranch, int* p_nbounds, int nbounds_size, char cbndtype[], int mbndcol[], double dbndval[]);

*Arguments*

`obranch`: The branching object to inspect.
`ibranch`: The number of the branch to get the bounds for.
`p_nbounds`: Location where the number of bounds for the given branch should be returned.
`nbounds_size`: Maximum number of bounds to return.
`cbndtype`: Character array of length
`nbounds_size where the types of bounds will be returned:`: L
`Lower bound.`: U
`Upper bound.`: Allowed to be NULL.
`mbndcol`: Integer array of length
`nbounds_size where the column indices will be returned. Allowed to be NULL.`: dbndval
`Double array of length`: nbounds_size where the bound values will be returned. Allowed to be NULL.

*Example*



*Related*

XPRS_bo_create,
XPRS_bo_addbounds.
"""
function _bo_getbounds(obranch, ibranch, p_nbounds, nbounds_size, cbndtype, mbndcol, dbndval)
    @checked Lib.XPRS_bo_getbounds(obranch, ibranch, p_nbounds, nbounds_size, cbndtype, mbndcol, dbndval)
end

"""

    _bo_addrows(obranch, ibranch, nrows, nelems, crtype, drrhs, mrbeg, mcol, dval)

*Purpose*

Adds new constraints to a branch of a user branching object.

*Synopsis*

int XPRS_CC XPRS_bo_addrows(XPRSbranchobject obranch, int ibranch, int nrows, int nelems, const char crtype[], const double drrhs[], const int mrbeg[], const int mcol[], const double dval[]);

*Arguments*

`obranch`: The user branching object to modify.
`ibranch`: The number of the branch to add the new constraints for. This branch must already have been created using
`XPRS_bo_addbranches. Branches are indexed starting from zero.`: nrows
`Number of new constraints to add.`: nelems
`Number of non-zero coefficients in all new constraints.`: crtype
`Character array of length`: nrows indicating the type of constraints to add:
`L`: Less than type.
`G`: Greater than type.
`E`: Equality type.
`drrhs`: Double array of length
`nrows containing the right hand side values.`: mrbeg
`Integer array of length`: nrows containing the offsets of the
`mcol and`: dval arrays of the start of the non zero coefficients in the new constraints.
`mcol`: Integer array of length
`nelems containing the column indices for the non zero coefficients.`: dval
`Double array of length`: nelems containing the non zero coefficient values.

*Example*

The following function will create a branching object that branches on constraints
x_1 + x_2 â¥ 1 or
x_1 + x_2 â¤ 0:

*Related*

XPRS_bo_create.
"""
function _bo_addrows(obranch, ibranch, nrows, nelems, crtype, drrhs, mrbeg, mcol, dval)
    @checked Lib.XPRS_bo_addrows(obranch, ibranch, nrows, nelems, crtype, drrhs, mrbeg, mcol, dval)
end

"""

    _bo_getrows(obranch, ibranch, p_nrows, nrows_size, p_nelems, nelems_size, crtype, drrhs, mrbeg, mcol, dval)

*Purpose*

Returns the constraints for a branch of a user branching object.

*Synopsis*

int XPRS_CC XPRS_bo_getrows(XPRSbranchobject obranch, int ibranch, int* p_nrows, int nrows_size, int* p_nelems, int nelems_size, char crtype[], double drrhs[], int mrbeg[], int mcol[], double dval[]);

*Arguments*

`obranch`: The user branching object to inspect.
`ibranch`: The number of the branch to get the constraints from.
`p_nrows`: Memory location where the number of rows should be returned.
`nrows_size`: Maximum number of rows to return.
`p_nelems`: Memory location where the number of non zero coefficients in the constraints should be returned.
`nelems_size`: Maximum number of non zero coefficients to return.
`crtype`: Character array of length
`nrows_size where the types of the rows will be returned:`: L
`Less than type.`: G
`Greater than type.`: E
`Equality type.`: drrhs
`Double array of length`: nrows_size where the right hand side values will be returned.
`mrbeg`: Integer array of length
`nrows_size which will be filled with the offsets of the`: mcol and
`dval arrays of the start of the non zero coefficients in the returned constraints.`: mcol
`Integer array of length`: nelems_size which will be filled with the column indices for the non zero coefficients.
`dval`: Double array of length

*Example*



*Related*

XPRS_bo_create,
XPRS_bo_addrows.
"""
function _bo_getrows(obranch, ibranch, p_nrows, nrows_size, p_nelems, nelems_size, crtype, drrhs, mrbeg, mcol, dval)
    @checked Lib.XPRS_bo_getrows(obranch, ibranch, p_nrows, nrows_size, p_nelems, nelems_size, crtype, drrhs, mrbeg, mcol, dval)
end

"""

    _bo_addcuts(obranch, ibranch, ncuts, mcutind)

*Purpose*

Adds stored user cuts as new constraints to a branch of a user branching object.

*Synopsis*

int XPRS_CC XPRS_bo_addcuts(XPRSbranchobject obranch, int ibranch, int ncuts, const XPRScut mcutind[]);

*Arguments*

`obranch`: The user branching object to modify.
`ibranch`: The number of the branch to add the cuts for. This branch must already have been created using
`XPRS_bo_addbranches. Branches are indexed starting from zero.`: ncuts
`Number of cuts to add.`: mcutind
`Array of length`: ncuts containing the pointers to user cuts that should be added to the branch.

*Example*



*Related*

XPRS_bo_create,
XPRS_bo_addrows.
"""
function _bo_addcuts(obranch, ibranch, ncuts, mcutind)
    @checked Lib.XPRS_bo_addcuts(obranch, ibranch, ncuts, mcutind)
end

"""

    _bo_getid(obranch, p_id)

*Purpose*

Returns the unique identifier assigned to a branching object.

*Synopsis*

int XPRS_CC XPRS_bo_getid(XPRSbranchobject obranch, int* p_id);

*Arguments*

`obranch`: A branching object.
`p_id`: Pointer to an integer where the identifier should be returned.

*Example*



*Related*

XPRS_bo_create.
"""
function _bo_getid(obranch, p_id)
    @checked Lib.XPRS_bo_getid(obranch, p_id)
end

"""

    _bo_getlasterror(obranch, iMsgCode, _msg, _iStringBufferBytes, _iBytesInInternalString)

*Purpose*

Returns the last error encountered during a call to the given branch object.

*Synopsis*

int XPRS_CC XPRS_bo_getlasterror(XPRSbranchobject obranch, int* iMsgCode, char* _msg, int _iStringBufferBytes, int* _iBytesInInternalString);

*Arguments*

`obranch`: The branch object.
`iMsgCode`: Location where the error code will be returned. Can be NULL if not required.
`_msg`: A character buffer of size
`iStringBufferBytes in which the last error message relating to the given branching object will be returned.`: iStringBufferBytes
`The size of the character buffer`: _msg.
`_iBytesInInternalString`: The size of the required character buffer to fully return the error string.

*Example*

The following shows how this function might be used in error checking:

*Related*

XPRS_ge_setcbmsghandler.
"""
function _bo_getlasterror(obranch, iMsgCode, _msg, _iStringBufferBytes, _iBytesInInternalString)
    @checked Lib.XPRS_bo_getlasterror(obranch, iMsgCode, _msg, _iStringBufferBytes, _iBytesInInternalString)
end

"""

    _bo_validate(obranch, p_status)

*Purpose*

Verifies that a given branching object is valid for branching on the current branch-and-bound node of a MIP solve. The function will check that all branches are non-empty, and if required, verify that the branching object can be presolved.

*Synopsis*

int XPRS_CC XPRS_bo_validate(XPRSbranchobject obranch, int* p_status);

*Arguments*

`obranch`: A branching object.
`p_status`: The returned status from checking the provided branching object:
`0`: The object is acceptable.
`1`: Failed to presolve the object due to dual reductions in presolve.
`2`: Failed to presolve the object due to duplicate column reductions in presolve.
`3`: The object contains an empty branch.

*Example*



*Related*

XPRS_bo_create.
"""
function _bo_validate(obranch, p_status)
    @checked Lib.XPRS_bo_validate(obranch, p_status)
end
