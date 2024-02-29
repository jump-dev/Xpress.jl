# Copyright (c) 2016: Joaquim Garcia, and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

#=

File automatically generated with script:
Xpress.jl/scripts/build_param_control_dicts.jl

Last build: 2023-04-05T15:30:42.197

Optimizer version: 41.1.3

Banner from lib:
###

Banner from header (xprs.h):
 * (c) Copyright Fair Isaac Corporation 1983-2023. All rights reserved     *
 * For FICO Xpress Optimizer v41.01.03                                     *

=#

const STRING_CONTROLS = Dict{String, Int32}(
    "MPSRHSNAME" => 6001,
    "MPSOBJNAME" => 6002,
    "MPSRANGENAME" => 6003,
    "MPSBOUNDNAME" => 6004,
    "OUTPUTMASK" => 6005,
    "TUNERMETHODFILE" => 6017,
    "TUNEROUTPUTPATH" => 6018,
    "TUNERSESSIONNAME" => 6019,
    "COMPUTEEXECSERVICE" => 6022,
)

const DOUBLE_CONTROLS = Dict{String, Int32}(
    "MAXCUTTIME" => 8149,
    "MAXSTALLTIME" => 8443,
    "TUNERMAXTIME" => 8364,
    "MATRIXTOL" => 7001,
    "PIVOTTOL" => 7002,
    "FEASTOL" => 7003,
    "OUTPUTTOL" => 7004,
    "SOSREFTOL" => 7005,
    "OPTIMALITYTOL" => 7006,
    "ETATOL" => 7007,
    "RELPIVOTTOL" => 7008,
    "MIPTOL" => 7009,
    "MIPTOLTARGET" => 7010,
    "BARPERTURB" => 7011,
    "MIPADDCUTOFF" => 7012,
    "MIPABSCUTOFF" => 7013,
    "MIPRELCUTOFF" => 7014,
    "PSEUDOCOST" => 7015,
    "PENALTY" => 7016,
    "BIGM" => 7018,
    "MIPABSSTOP" => 7019,
    "MIPRELSTOP" => 7020,
    "CROSSOVERACCURACYTOL" => 7023,
    "PRIMALPERTURB" => 7024,
    "DUALPERTURB" => 7025,
    "BAROBJSCALE" => 7026,
    "BARRHSSCALE" => 7027,
    "CHOLESKYTOL" => 7032,
    "BARGAPSTOP" => 7033,
    "BARDUALSTOP" => 7034,
    "BARPRIMALSTOP" => 7035,
    "BARSTEPSTOP" => 7036,
    "ELIMTOL" => 7042,
    "PERTURB" => 7044, # kept for compatibility
    "MARKOWITZTOL" => 7047,
    "MIPABSGAPNOTIFY" => 7064,
    "MIPRELGAPNOTIFY" => 7065,
    "BARLARGEBOUND" => 7067,
    "PPFACTOR" => 7069,
    "REPAIRINDEFINITEQMAX" => 7071,
    "BARGAPTARGET" => 7073,
    "DUMMYCONTROL" => 7075,
    "BARSTARTWEIGHT" => 7076,
    "BARFREESCALE" => 7077,
    "SBEFFORT" => 7086,
    "HEURDIVERANDOMIZE" => 7089,
    "HEURSEARCHEFFORT" => 7090,
    "CUTFACTOR" => 7091,
    "EIGENVALUETOL" => 7097,
    "INDLINBIGM" => 7099,
    "TREEMEMORYSAVINGTARGET" => 7100,
    "GLOBALFILEBIAS" => 7101, # kept for compatibility
    "INDPRELINBIGM" => 7102,
    "RELAXTREEMEMORYLIMIT" => 7105,
    "MIPABSGAPNOTIFYOBJ" => 7108,
    "MIPABSGAPNOTIFYBOUND" => 7109,
    "PRESOLVEMAXGROW" => 7110,
    "HEURSEARCHTARGETSIZE" => 7112,
    "CROSSOVERRELPIVOTTOL" => 7113,
    "CROSSOVERRELPIVOTTOLSAFE" => 7114,
    "DETLOGFREQ" => 7116,
    "MAXIMPLIEDBOUND" => 7120,
    "FEASTOLTARGET" => 7121,
    "OPTIMALITYTOLTARGET" => 7122,
    "PRECOMPONENTSEFFORT" => 7124,
    "LPLOGDELAY" => 7127,
    "HEURDIVEITERLIMIT" => 7128,
    "BARKERNEL" => 7130,
    "FEASTOLPERTURB" => 7132,
    "CROSSOVERFEASWEIGHT" => 7133,
    "LUPIVOTTOL" => 7139,
    "MIPRESTARTGAPTHRESHOLD" => 7140,
    "NODEPROBINGEFFORT" => 7141,
    "INPUTTOL" => 7143,
    "MIPRESTARTFACTOR" => 7145,
    "BAROBJPERTURB" => 7146,
    "CPIALPHA" => 7149,
    "GLOBALBOUNDINGBOX" => 7154,
    "TIMELIMIT" => 7158,
    "SOLTIMELIMIT" => 7159,
    "REPAIRINFEASTIMELIMIT" => 7160,
)

const INTEGER_CONTROLS = Dict{String, Int32}(
    "EXTRAROWS" => 8004,
    "EXTRACOLS" => 8005,
    "LPITERLIMIT" => 8007,
    "LPLOG" => 8009,
    "SCALING" => 8010,
    "PRESOLVE" => 8011,
    "CRASH" => 8012,
    "PRICINGALG" => 8013,
    "INVERTFREQ" => 8014,
    "INVERTMIN" => 8015,
    "MAXNODE" => 8018,
    "MAXTIME" => 8020, # kept for compatibility
    "MAXMIPSOL" => 8021,
    "SIFTPASSES" => 8022,
    "DEFAULTALG" => 8023,
    "VARSELECTION" => 8025,
    "NODESELECTION" => 8026,
    "BACKTRACK" => 8027,
    "MIPLOG" => 8028,
    "KEEPNROWS" => 8030,
    "MPSECHO" => 8032,
    "MAXPAGELINES" => 8034,
    "OUTPUTLOG" => 8035,
    "BARSOLUTION" => 8038,
    "CACHESIZE" => 8043, # kept for compatibility
    "CROSSOVER" => 8044,
    "BARITERLIMIT" => 8045,
    "CHOLESKYALG" => 8046,
    "BAROUTPUT" => 8047,
    "CSTYLE" => 8050, # kept for compatibility
    "EXTRAMIPENTS" => 8051,
    "REFACTOR" => 8052,
    "BARTHREADS" => 8053,
    "KEEPBASIS" => 8054,
    "CROSSOVEROPS" => 8060,
    "VERSION" => 8061,
    "CROSSOVERTHREADS" => 8065,
    "BIGMMETHOD" => 8068,
    "MPSNAMELENGTH" => 8071,
    "ELIMFILLIN" => 8073,
    "PRESOLVEOPS" => 8077,
    "MIPPRESOLVE" => 8078,
    "MIPTHREADS" => 8079,
    "BARORDER" => 8080,
    "BREADTHFIRST" => 8082,
    "AUTOPERTURB" => 8084,
    "DENSECOLLIMIT" => 8086,
    "CALLBACKFROMMASTERTHREAD" => 8090,
    "MAXMCOEFFBUFFERELEMS" => 8091,
    "REFINEOPS" => 8093,
    "LPREFINEITERLIMIT" => 8094,
    "MIPREFINEITERLIMIT" => 8095,
    "DUALIZEOPS" => 8097,
    "CROSSOVERITERLIMIT" => 8104,
    "PREBASISRED" => 8106,
    "PRESORT" => 8107,
    "PREPERMUTE" => 8108,
    "PREPERMUTESEED" => 8109,
    "MAXMEMORYSOFT" => 8112,
    "CUTFREQ" => 8116,
    "SYMSELECT" => 8117,
    "SYMMETRY" => 8118,
    "MAXMEMORYHARD" => 8119,
    "LPTHREADS" => 8124, # kept for compatibility
    "MIQCPALG" => 8125,
    "QCCUTS" => 8126,
    "QCROOTALG" => 8127,
    "PRECONVERTSEPARABLE" => 8128,
    "ALGAFTERNETWORK" => 8129,
    "TRACE" => 8130,
    "MAXIIS" => 8131,
    "CPUTIME" => 8133,
    "COVERCUTS" => 8134,
    "GOMCUTS" => 8135,
    "LPFOLDING" => 8136,
    "MPSFORMAT" => 8137,
    "CUTSTRATEGY" => 8138,
    "CUTDEPTH" => 8139,
    "TREECOVERCUTS" => 8140,
    "TREEGOMCUTS" => 8141,
    "CUTSELECT" => 8142,
    "TREECUTSELECT" => 8143,
    "DUALIZE" => 8144,
    "DUALGRADIENT" => 8145,
    "SBITERLIMIT" => 8146,
    "SBBEST" => 8147,
    "MAXCUTTIME" => 8149, # kept for compatibility
    "ACTIVESET" => 8152, # kept for compatibility
    "BARINDEFLIMIT" => 8153,
    "HEURSTRATEGY" => 8154, # kept for compatibility
    "HEURFREQ" => 8155,
    "HEURDEPTH" => 8156,
    "HEURMAXSOL" => 8157,
    "HEURNODES" => 8158,
    "LNPBEST" => 8160,
    "LNPITERLIMIT" => 8161,
    "BRANCHCHOICE" => 8162,
    "BARREGULARIZE" => 8163,
    "SBSELECT" => 8164,
    "LOCALCHOICE" => 8170,
    "LOCALBACKTRACK" => 8171,
    "DUALSTRATEGY" => 8174,
    "L1CACHE" => 8175, # kept for compatibility
    "HEURDIVESTRATEGY" => 8177,
    "HEURSELECT" => 8178,
    "BARSTART" => 8180,
    "PRESOLVEPASSES" => 8183,
    "BARNUMSTABILITY" => 8186,
    "BARORDERTHREADS" => 8187,
    "EXTRASETS" => 8190,
    "FEASIBILITYPUMP" => 8193,
    "PRECOEFELIM" => 8194,
    "PREDOMCOL" => 8195,
    "HEURSEARCHFREQ" => 8196,
    "HEURDIVESPEEDUP" => 8197,
    "SBESTIMATE" => 8198,
    "BARCORES" => 8202,
    "MAXCHECKSONMAXTIME" => 8203,
    "MAXCHECKSONMAXCUTTIME" => 8204,
    "HISTORYCOSTS" => 8206,
    "ALGAFTERCROSSOVER" => 8208,
    "LINELENGTH" => 8209, # kept for compatibility
    "MUTEXCALLBACKS" => 8210,
    "BARCRASH" => 8211,
    "HEURDIVESOFTROUNDING" => 8215,
    "HEURSEARCHROOTSELECT" => 8216,
    "HEURSEARCHTREESELECT" => 8217,
    "MPS18COMPATIBLE" => 8223,
    "ROOTPRESOLVE" => 8224,
    "CROSSOVERDRP" => 8227,
    "FORCEOUTPUT" => 8229,
    "PRIMALOPS" => 8231,
    "DETERMINISTIC" => 8232,
    "PREPROBING" => 8238,
    "EXTRAQCELEMENTS" => 8240, # kept for compatibility
    "EXTRAQCROWS" => 8241, # kept for compatibility
    "TREEMEMORYLIMIT" => 8242,
    "TREECOMPRESSION" => 8243,
    "TREEDIAGNOSTICS" => 8244,
    "MAXTREEFILESIZE" => 8245,
    "MAXGLOBALFILESIZE" => 8245, # kept for compatibility
    "PRECLIQUESTRATEGY" => 8247,
    "REPAIRINFEASMAXTIME" => 8250, # kept for compatibility
    "IFCHECKCONVEXITY" => 8251,
    "PRIMALUNSHIFT" => 8252,
    "REPAIRINDEFINITEQ" => 8254,
    "MIPRAMPUP" => 8255,
    "MAXLOCALBACKTRACK" => 8257,
    "USERSOLHEURISTIC" => 8258,
    "FORCEPARALLELDUAL" => 8265,
    "BACKTRACKTIE" => 8266,
    "BRANCHDISJ" => 8267,
    "MIPFRACREDUCE" => 8270,
    "CONCURRENTTHREADS" => 8274,
    "MAXSCALEFACTOR" => 8275,
    "HEURTHREADS" => 8276,
    "THREADS" => 8278,
    "HEURBEFORELP" => 8280,
    "PREDOMROW" => 8281,
    "BRANCHSTRUCTURAL" => 8282,
    "QUADRATICUNSHIFT" => 8284,
    "BARPRESOLVEOPS" => 8286,
    "QSIMPLEXOPS" => 8288,
    "MIPRESTART" => 8290,
    "CONFLICTCUTS" => 8292,
    "PREPROTECTDUAL" => 8293,
    "CORESPERCPU" => 8296,
    "RESOURCESTRATEGY" => 8297,
    "CLAMPING" => 8301,
    "SLEEPONTHREADWAIT" => 8302,
    "PREDUPROW" => 8307,
    "CPUPLATFORM" => 8312,
    "BARALG" => 8315,
    "SIFTING" => 8319,
    "TREEPRESOLVE" => 8320, # Not in v38, kept for backwards compatibility.
    "TREEPRESOLVE_KEEPBASIS" => 8321, # Not in v38, kept for backwards compatibility.
    "TREEPRESOLVEOPS" => 8322, # Not in v38, kept for backwards compatibility.
    "LPLOGSTYLE" => 8326,
    "RANDOMSEED" => 8328,
    "TREEQCCUTS" => 8331,
    "PRELINDEP" => 8333,
    "DUALTHREADS" => 8334,
    "PREOBJCUTDETECT" => 8336,
    "PREBNDREDQUAD" => 8337,
    "PREBNDREDCONE" => 8338,
    "PRECOMPONENTS" => 8339,
    "MAXMIPTASKS" => 8347,
    "MIPTERMINATIONMETHOD" => 8348,
    "PRECONEDECOMP" => 8349,
    "HEURFORCESPECIALOBJ" => 8350,
    "HEURSEARCHROOTCUTFREQ" => 8351,
    "PREELIMQUAD" => 8353,
    "PREIMPLICATIONS" => 8356,
    "TUNERMODE" => 8359,
    "TUNERMETHOD" => 8360,
    "TUNERTARGET" => 8362,
    "TUNERTHREADS" => 8363,
    "TUNERMAXTIME" => 8364, # kept for compatibility
    "TUNERHISTORY" => 8365,
    "TUNERPERMUTE" => 8366,
    "TUNERROOTALG" => 8367, # kept for compatibility
    "TUNERVERBOSE" => 8370,
    "TUNEROUTPUT" => 8372,
    "PREANALYTICCENTER" => 8374,
    "NETCUTS" => 8382,
    "LPFLAGS" => 8385,
    "MIPKAPPAFREQ" => 8386,
    "OBJSCALEFACTOR" => 8387,
    "TREEFILELOGINTERVAL" => 8389,
    "GLOBALFILELOGINTERVAL" => 8389, # kept for compatibility
    "IGNORECONTAINERCPULIMIT" => 8390,
    "IGNORECONTAINERMEMORYLIMIT" => 8391,
    "MIPDUALREDUCTIONS" => 8392,
    "GENCONSDUALREDUCTIONS" => 8395,
    "PWLDUALREDUCTIONS" => 8396,
    "BARFAILITERLIMIT" => 8398,
    "AUTOSCALING" => 8406,
    "GENCONSABSTRANSFORMATION" => 8408,
    "COMPUTEJOBPRIORITY" => 8409,
    "PREFOLDING" => 8410,
    "COMPUTE" => 8411,
    "NETSTALLLIMIT" => 8412,
    "SERIALIZEPREINTSOL" => 8413,
    "NUMERICALEMPHASIS" => 8416,
    "PWLNONCONVEXTRANSFORMATION" => 8420,
    "MIPCOMPONENTS" => 8421,
    "MIPCONCURRENTNODES" => 8422,
    "MIPCONCURRENTSOLVES" => 8423,
    "OUTPUTCONTROLS" => 8424,
    "SIFTSWITCH" => 8425,
    "HEUREMPHASIS" => 8427,
    "COMPUTEMATX" => 8428,
    "COMPUTEMATX_IIS" => 8429,
    "COMPUTEMATX_IISMAXTIME" => 8430,
    "BARREFITER" => 8431,
    "COMPUTELOG" => 8434,
    "SIFTPRESOLVEOPS" => 8435,
    "CHECKINPUTDATA" => 8436,
    "ESCAPENAMES" => 8440,
    "IOTIMEOUT" => 8442,
    "MAXSTALLTIME" => 8443, # kept for compatibility
    "AUTOCUTTING" => 8446,
    "CALLBACKCHECKTIMEDELAY" => 8451,
    "MULTIOBJOPS" => 8457,
    "MULTIOBJLOG" => 8458,
    "GLOBALSPATIALBRANCHIFPREFERORIG" => 8465,
    "PRECONFIGURATION" => 8470,
    "FEASIBILITYJUMP" => 8471,
    "EXTRAELEMS" => 8006,
    "EXTRAPRESOLVE" => 8037, # kept for compatibility
    "EXTRASETELEMS" => 8191,
)

const STRING_ATTRIBUTES = Dict{String, Int32}(
    "MATRIXNAME" => 3001,
    "BOUNDNAME" => 3002,
    "OBJNAME" => 3003, # kept for compatibility
    "RHSNAME" => 3004,
    "RANGENAME" => 3005,
    "XPRESSVERSION" => 3010,
    "UUID" => 3011,
)

const DOUBLE_ATTRIBUTES = Dict{String, Int32}(
    "MIPSOLTIME" => 1371,
    "TIME" => 1122,
    "LPOBJVAL" => 2001,
    "SUMPRIMALINF" => 2002,
    "MIPOBJVAL" => 2003,
    "BESTBOUND" => 2004,
    "OBJRHS" => 2005,
    "MIPBESTOBJVAL" => 2006,
    "OBJSENSE" => 2008,
    "BRANCHVALUE" => 2009,
    "PENALTYVALUE" => 2061,
    "CURRMIPCUTOFF" => 2062,
    "BARCONDA" => 2063,
    "BARCONDD" => 2064,
    "MAXABSPRIMALINFEAS" => 2073,
    "MAXRELPRIMALINFEAS" => 2074,
    "MAXABSDUALINFEAS" => 2075,
    "MAXRELDUALINFEAS" => 2076,
    "PRIMALDUALINTEGRAL" => 2079,
    "MAXMIPINFEAS" => 2083,
    "ATTENTIONLEVEL" => 2097,
    "MAXKAPPA" => 2098,
    "TREECOMPLETION" => 2104,
    "PREDICTEDATTLEVEL" => 2105,
    "OBSERVEDPRIMALINTEGRAL" => 2106,
    "CPISCALEFACTOR" => 2117,
    "OBJVAL" => 2118,
    "BARPRIMALOBJ" => 4001,
    "BARDUALOBJ" => 4002,
    "BARPRIMALINF" => 4003,
    "BARDUALINF" => 4004,
    "BARCGAP" => 4005,
)

const INTEGER_ATTRIBUTES = Dict{String, Int32}(
    "ROWS" => 1001,
    "SETS" => 1004,
    "PRIMALINFEAS" => 1007,
    "DUALINFEAS" => 1008,
    "SIMPLEXITER" => 1009,
    "LPSTATUS" => 1010,
    "MIPSTATUS" => 1011,
    "CUTS" => 1012,
    "NODES" => 1013,
    "NODEDEPTH" => 1014,
    "ACTIVENODES" => 1015,
    "MIPSOLNODE" => 1016,
    "MIPSOLS" => 1017,
    "COLS" => 1018,
    "SPAREROWS" => 1019,
    "SPARECOLS" => 1020,
    "SPAREMIPENTS" => 1022,
    "ERRORCODE" => 1023,
    "MIPINFEAS" => 1024,
    "PRESOLVESTATE" => 1026,
    "PARENTNODE" => 1027,
    "NAMELENGTH" => 1028,
    "QELEMS" => 1030,
    "NUMIIS" => 1031,
    "MIPENTS" => 1032,
    "BRANCHVAR" => 1036,
    "MIPTHREADID" => 1037,
    "ALGORITHM" => 1049,
    "SOLSTATUS" => 1053,
    "TIME" => 1122, # kept for compatibility
    "ORIGINALROWS" => 1124,
    "CALLBACKCOUNT_OPTNODE" => 1136,
    "CALLBACKCOUNT_CUTMGR" => 1137,
    "ORIGINALQELEMS" => 1157,
    "MAXPROBNAMELENGTH" => 1158,
    "STOPSTATUS" => 1179,
    "ORIGINALMIPENTS" => 1191,
    "ORIGINALSETS" => 1194,
    "SPARESETS" => 1203,
    "CHECKSONMAXTIME" => 1208,
    "CHECKSONMAXCUTTIME" => 1209,
    "ORIGINALCOLS" => 1214,
    "QCELEMS" => 1232,
    "QCONSTRAINTS" => 1234,
    "ORIGINALQCELEMS" => 1237,
    "ORIGINALQCONSTRAINTS" => 1239,
    "PEAKTOTALTREEMEMORYUSAGE" => 1240,
    "CURRENTNODE" => 1248,
    "TREEMEMORYUSAGE" => 1251,
    "TREEFILESIZE" => 1252,
    "TREEFILEUSAGE" => 1253,
    "GLOBALFILESIZE" => 1252, # kept for compatibility
    "GLOBALFILEUSAGE" => 1253, # kept for compatibility
    "INDICATORS" => 1254,
    "ORIGINALINDICATORS" => 1255,
    "CORESPERCPUDETECTED" => 1258,
    "CPUSDETECTED" => 1259,
    "CORESDETECTED" => 1260,
    "PHYSICALCORESDETECTED" => 1261,
    "PHYSICALCORESPERCPUDETECTED" => 1262,
    "BARSING" => 1281,
    "BARSINGR" => 1282,
    "PRESOLVEINDEX" => 1284,
    "CONES" => 1307,
    "CONEELEMS" => 1308,
    "PWLCONS" => 1325,
    "GENCONS" => 1327,
    "TREERESTARTS" => 1335,
    "ORIGINALPWLS" => 1336,
    "ORIGINALGENCONS" => 1338,
    "COMPUTEEXECUTIONS" => 1356,
    "MIPSOLTIME" => 1371, # kept for compatibility
    "RESTARTS" => 1381,
    "SOLVESTATUS" => 1394,
    "GLOBALBOUNDINGBOXAPPLIED" => 1396,
    "OBJECTIVES" => 1397,
    "SOLVEDOBJS" => 1399,
    "OBJSTOSOLVE" => 1400,
    "GLOBALNLPINFEAS" => 1403,
    "BARITER" => 5001,
    "BARDENSECOL" => 5004,
    "BARCROSSOVER" => 5005,
    "SETMEMBERS" => 1005,
    "ELEMS" => 1006,
    "SPAREELEMS" => 1021,
    "SYSTEMMEMORY" => 1148,
    "ORIGINALSETMEMBERS" => 1195,
    "SPARESETELEMS" => 1204,
    "CURRENTMEMORY" => 1285,
    "PEAKMEMORY" => 1286,
    "TOTALMEMORY" => 1322,
    "AVAILABLEMEMORY" => 1324,
    "PWLPOINTS" => 1326,
    "GENCONCOLS" => 1328,
    "GENCONVALS" => 1329,
    "ORIGINALPWLPOINTS" => 1337,
    "ORIGINALGENCONCOLS" => 1339,
    "ORIGINALGENCONVALS" => 1340,
    "MEMORYLIMITDETECTED" => 1380,
    "BARAASIZE" => 5002,
    "BARLSIZE" => 5003,
)

const STRING_CONTROLS_VALUES = values(STRING_CONTROLS)

const DOUBLE_CONTROLS_VALUES = values(DOUBLE_CONTROLS)

const INTEGER_CONTROLS_VALUES = values(INTEGER_CONTROLS)

const STRING_ATTRIBUTES_VALUES = values(STRING_ATTRIBUTES)

const DOUBLE_ATTRIBUTES_VALUES = values(DOUBLE_ATTRIBUTES)

const INTEGER_ATTRIBUTES_VALUES = values(INTEGER_ATTRIBUTES)
