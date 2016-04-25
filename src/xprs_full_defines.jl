# defined for julia interface
const XPRS_LEQ = convert(Cchar,'L')
const XPRS_GEQ = convert(Cchar,'G')
const XPRS_EQ = convert(Cchar,'E')

const XPRS_CONTINUOUS = convert(Cchar, 'C')
const XPRS_BINARY     = convert(Cchar, 'B')
const XPRS_INTEGER    = convert(Cchar, 'I')

const XPRS_SOS_TYPE1 = convert(Cchar, '1')
const XPRS_SOS_TYPE2 = convert(Cchar, '2')


#***************************************************************************\
# * useful constants                                                        *
#***************************************************************************/
const XPRS_PLUSINFINITY  = convert(Cdouble,     1.0e+20 )
const XPRS_MINUSINFINITY = convert(Cdouble,    -1.0e+20 )
const XPRS_MAXINT        = convert(Cint,  2147483647 )
const XPVERSION          = convert(Cint,          27 )

#***************************************************************************\
# * control parameters for XPRSprob                                         *
#***************************************************************************/
# String control parameters */
const XPRS_MPSRHSNAME    = convert(Int ,                          6001)
const XPRS_MPSOBJNAME    = convert(Int ,                          6002)
const XPRS_MPSRANGENAME  = convert(Int ,                          6003)
const XPRS_MPSBOUNDNAME  = convert(Int ,                          6004)
const XPRS_OUTPUTMASK    = convert(Int ,                          6005)
#/* Double control parameters */
const XPRS_MATRIXTOL                  =convert(Int,               7001 )
const XPRS_PIVOTTOL                   =convert(Int,               7002 )
const XPRS_FEASTOL                    =convert(Int,               7003 )
const XPRS_OUTPUTTOL                  =convert(Int,               7004 )
const XPRS_SOSREFTOL                  =convert(Int,               7005 )
const XPRS_OPTIMALITYTOL              =convert(Int,               7006 )
const XPRS_ETATOL                     =convert(Int,               7007 )
const XPRS_RELPIVOTTOL                =convert(Int,               7008 )
const XPRS_MIPTOL                     =convert(Int,               7009 )
const XPRS_MIPADDCUTOFF               =convert(Int,               7012 )
const XPRS_MIPABSCUTOFF               =convert(Int,               7013 )
const XPRS_MIPRELCUTOFF               =convert(Int,               7014 )
const XPRS_PSEUDOCOST                 =convert(Int,               7015 )
const XPRS_PENALTY                    =convert(Int,               7016 )
const XPRS_BIGM                       =convert(Int,               7018 )
const XPRS_MIPABSSTOP                 =convert(Int,               7019 )
const XPRS_MIPRELSTOP                 =convert(Int,               7020 )
const XPRS_CROSSOVERACCURACYTOL       =convert(Int,               7023 )
const XPRS_CHOLESKYTOL                =convert(Int,               7032 )
const XPRS_BARGAPSTOP                 =convert(Int,               7033 )
const XPRS_BARDUALSTOP                =convert(Int,               7034 )
const XPRS_BARPRIMALSTOP              =convert(Int,               7035 )
const XPRS_BARSTEPSTOP                =convert(Int,               7036 )
const XPRS_ELIMTOL                    =convert(Int,               7042 )
const XPRS_PERTURB                    =convert(Int,               7044 )
const XPRS_MARKOWITZTOL               =convert(Int,               7047 )
const XPRS_MIPABSGAPNOTIFY            =convert(Int,               7064 )
const XPRS_MIPRELGAPNOTIFY            =convert(Int,               7065 )
const XPRS_PPFACTOR                   =convert(Int,               7069 )
const XPRS_REPAIRINDEFINITEQMAX       =convert(Int,               7071 )
const XPRS_BARGAPTARGET               =convert(Int,               7073 )
const XPRS_SBEFFORT                   =convert(Int,               7086 )
const XPRS_HEURDIVERANDOMIZE          =convert(Int,               7089 )
const XPRS_HEURSEARCHEFFORT           =convert(Int,               7090 )
const XPRS_CUTFACTOR                  =convert(Int,               7091 )
const XPRS_EIGENVALUETOL              =convert(Int,               7097 )
const XPRS_INDLINBIGM                 =convert(Int,               7099 )
const XPRS_TREEMEMORYSAVINGTARGET     =convert(Int,               7100 )
const XPRS_GLOBALFILEBIAS             =convert(Int,               7101 )
const XPRS_INDPRELINBIGM              =convert(Int,               7102 )
const XPRS_RELAXTREEMEMORYLIMIT       =convert(Int,               7105 )
const XPRS_MIPABSGAPNOTIFYOBJ         =convert(Int,               7108 )
const XPRS_MIPABSGAPNOTIFYBOUND       =convert(Int,               7109 )
const XPRS_PRESOLVEMAXGROW            =convert(Int,               7110 )
const XPRS_HEURSEARCHTARGETSIZE       =convert(Int,               7112 )
const XPRS_CROSSOVERRELPIVOTTOL       =convert(Int,               7113 )
const XPRS_CROSSOVERRELPIVOTTOLSAFE   =convert(Int,               7114 )
const XPRS_DETLOGFREQ                 =convert(Int,               7116 )
const XPRS_FEASTOLTARGET              =convert(Int,               7121 )
const XPRS_OPTIMALITYTOLTARGET        =convert(Int,               7122 )
#/* Integer control parameters */
const XPRS_EXTRAROWS                  =convert(Int,               8004 )
const XPRS_EXTRACOLS                  =convert(Int,               8005 )
const XPRS_LPITERLIMIT                =convert(Int,               8007 )
const XPRS_LPLOG                      =convert(Int,               8009 )
const XPRS_SCALING                    =convert(Int,               8010 )
const XPRS_PRESOLVE                   =convert(Int,               8011 )
const XPRS_CRASH                      =convert(Int,               8012 )
const XPRS_PRICINGALG                 =convert(Int,               8013 )
const XPRS_INVERTFREQ                 =convert(Int,               8014 )
const XPRS_INVERTMIN                  =convert(Int,               8015 )
const XPRS_MAXNODE                    =convert(Int,               8018 )
const XPRS_MAXTIME                    =convert(Int,               8020 )
const XPRS_MAXMIPSOL                  =convert(Int,               8021 )
const XPRS_DEFAULTALG                 =convert(Int,               8023 )
const XPRS_VARSELECTION               =convert(Int,               8025 )
const XPRS_NODESELECTION              =convert(Int,               8026 )
const XPRS_BACKTRACK                  =convert(Int,               8027 )
const XPRS_MIPLOG                     =convert(Int,               8028 )
const XPRS_KEEPNROWS                  =convert(Int,               8030 )
const XPRS_MPSECHO                    =convert(Int,               8032 )
const XPRS_MAXPAGELINES               =convert(Int,               8034 )
const XPRS_OUTPUTLOG                  =convert(Int,               8035 )
const XPRS_BARSOLUTION                =convert(Int,               8038 )
const XPRS_CACHESIZE                  =convert(Int,               8043 )
const XPRS_CROSSOVER                  =convert(Int,               8044 )
const XPRS_BARITERLIMIT               =convert(Int,               8045 )
const XPRS_CHOLESKYALG                =convert(Int,               8046 )
const XPRS_BAROUTPUT                  =convert(Int,               8047 )
const XPRS_CSTYLE                     =convert(Int,               8050 )
const XPRS_EXTRAMIPENTS               =convert(Int,               8051 )
const XPRS_REFACTOR                   =convert(Int,               8052 )
const XPRS_BARTHREADS                 =convert(Int,               8053 )
const XPRS_KEEPBASIS                  =convert(Int,               8054 )
const XPRS_VERSION                    =convert(Int,               8061 )
const XPRS_BIGMMETHOD                 =convert(Int,               8068 )
const XPRS_MPSNAMELENGTH              =convert(Int,               8071 )
const XPRS_PRESOLVEOPS                =convert(Int,               8077 )
const XPRS_MIPPRESOLVE                =convert(Int,               8078 )
const XPRS_MIPTHREADS                 =convert(Int,               8079 )
const XPRS_BARORDER                   =convert(Int,               8080 )
const XPRS_BREADTHFIRST               =convert(Int,               8082 )
const XPRS_AUTOPERTURB                =convert(Int,               8084 )
const XPRS_DENSECOLLIMIT              =convert(Int,               8086 )
const XPRS_CALLBACKFROMMASTERTHREAD   =convert(Int,               8090 )
const XPRS_MAXMCOEFFBUFFERELEMS       =convert(Int,               8091 )
const XPRS_REFINEOPS                  =convert(Int,               8093 )
const XPRS_LPREFINEITERLIMIT          =convert(Int,               8094 )
const XPRS_DUALIZEOPS                 =convert(Int,               8097 )
const XPRS_MAXMEMORY                  =convert(Int,               8112 )
const XPRS_CUTFREQ                    =convert(Int,               8116 )
const XPRS_SYMSELECT                  =convert(Int,               8117 )
const XPRS_SYMMETRY                   =convert(Int,               8118 )
const XPRS_LPTHREADS                  =convert(Int,               8124 )
const XPRS_MIQCPALG                   =convert(Int,               8125 )
const XPRS_QCCUTS                     =convert(Int,               8126 )
const XPRS_QCROOTALG                  =convert(Int,               8127 )
const XPRS_ALGAFTERNETWORK            =convert(Int,               8129 )
const XPRS_TRACE                      =convert(Int,               8130 )
const XPRS_MAXIIS                     =convert(Int,               8131 )
const XPRS_CPUTIME                    =convert(Int,               8133 )
const XPRS_COVERCUTS                  =convert(Int,               8134 )
const XPRS_GOMCUTS                    =convert(Int,               8135 )
const XPRS_MPSFORMAT                  =convert(Int,               8137 )
const XPRS_CUTSTRATEGY                =convert(Int,               8138 )
const XPRS_CUTDEPTH                   =convert(Int,               8139 )
const XPRS_TREECOVERCUTS              =convert(Int,               8140 )
const XPRS_TREEGOMCUTS                =convert(Int,               8141 )
const XPRS_CUTSELECT                  =convert(Int,               8142 )
const XPRS_TREECUTSELECT              =convert(Int,               8143 )
const XPRS_DUALIZE                    =convert(Int,               8144 )
const XPRS_DUALGRADIENT               =convert(Int,               8145 )
const XPRS_SBITERLIMIT                =convert(Int,               8146 )
const XPRS_SBBEST                     =convert(Int,               8147 )
const XPRS_MAXCUTTIME                 =convert(Int,               8149 )
const XPRS_ACTIVESET                  =convert(Int,               8152 )
const XPRS_BARINDEFLIMIT              =convert(Int,               8153 )
const XPRS_HEURSTRATEGY               =convert(Int,               8154 )
const XPRS_HEURFREQ                   =convert(Int,               8155 )
const XPRS_HEURDEPTH                  =convert(Int,               8156 )
const XPRS_HEURMAXSOL                 =convert(Int,               8157 )
const XPRS_HEURNODES                  =convert(Int,               8158 )
const XPRS_LNPBEST                    =convert(Int,               8160 )
const XPRS_LNPITERLIMIT               =convert(Int,               8161 )
const XPRS_BRANCHCHOICE               =convert(Int,               8162 )
const XPRS_BARREGULARIZE              =convert(Int,               8163 )
const XPRS_SBSELECT                   =convert(Int,               8164 )
const XPRS_LOCALCHOICE                =convert(Int,               8170 )
const XPRS_LOCALBACKTRACK             =convert(Int,               8171 )
const XPRS_DUALSTRATEGY               =convert(Int,               8174 )
const XPRS_L1CACHE                    =convert(Int,               8175 )
const XPRS_HEURDIVESTRATEGY           =convert(Int,               8177 )
const XPRS_HEURSELECT                 =convert(Int,               8178 )
const XPRS_BARSTART                   =convert(Int,               8180 )
const XPRS_BARNUMSTABILITY            =convert(Int,               8186 )
const XPRS_EXTRASETS                  =convert(Int,               8190 )
const XPRS_FEASIBILITYPUMP            =convert(Int,               8193 )
const XPRS_PRECOEFELIM                =convert(Int,               8194 )
const XPRS_PREDOMCOL                  =convert(Int,               8195 )
const XPRS_HEURSEARCHFREQ             =convert(Int,               8196 )
const XPRS_HEURDIVESPEEDUP            =convert(Int,               8197 )
const XPRS_SBESTIMATE                 =convert(Int,               8198 )
const XPRS_BARCORES                   =convert(Int,               8202 )
const XPRS_MAXCHECKSONMAXTIME         =convert(Int,               8203 )
const XPRS_MAXCHECKSONMAXCUTTIME      =convert(Int,               8204 )
const XPRS_HISTORYCOSTS               =convert(Int,               8206 )
const XPRS_ALGAFTERCROSSOVER          =convert(Int,               8208 )
const XPRS_LINELENGTH                 =convert(Int,               8209 )
const XPRS_MUTEXCALLBACKS             =convert(Int,               8210 )
const XPRS_BARCRASH                   =convert(Int,               8211 )
const XPRS_HEURDIVESOFTROUNDING       =convert(Int,               8215 )
const XPRS_HEURSEARCHROOTSELECT       =convert(Int,               8216 )
const XPRS_HEURSEARCHTREESELECT       =convert(Int,               8217 )
const XPRS_MPS18COMPATIBLE            =convert(Int,               8223 )
const XPRS_ROOTPRESOLVE               =convert(Int,               8224 )
const XPRS_CROSSOVERDRP               =convert(Int,               8227 )
const XPRS_FORCEOUTPUT                =convert(Int,               8229 )
const XPRS_DETERMINISTIC              =convert(Int,               8232 )
const XPRS_PREPROBING                 =convert(Int,               8238 )
const XPRS_EXTRAQCELEMENTS            =convert(Int,               8240 )
const XPRS_EXTRAQCROWS                =convert(Int,               8241 )
const XPRS_TREEMEMORYLIMIT            =convert(Int,               8242 )
const XPRS_TREECOMPRESSION            =convert(Int,               8243 )
const XPRS_TREEDIAGNOSTICS            =convert(Int,               8244 )
const XPRS_MAXGLOBALFILESIZE          =convert(Int,               8245 )
const XPRS_TEMPBOUNDS                 =convert(Int,               8250 )
const XPRS_IFCHECKCONVEXITY           =convert(Int,               8251 )
const XPRS_PRIMALUNSHIFT              =convert(Int,               8252 )
const XPRS_REPAIRINDEFINITEQ          =convert(Int,               8254 )
const XPRS_MAXLOCALBACKTRACK          =convert(Int,               8257 )
const XPRS_BACKTRACKTIE               =convert(Int,               8266 )
const XPRS_BRANCHDISJ                 =convert(Int,               8267 )
const XPRS_MIPFRACREDUCE              =convert(Int,               8270 )
const XPRS_CONCURRENTTHREADS          =convert(Int,               8274 )
const XPRS_MAXSCALEFACTOR             =convert(Int,               8275 )
const XPRS_HEURTHREADS                =convert(Int,               8276 )
const XPRS_THREADS                    =convert(Int,               8278 )
const XPRS_HEURBEFORELP               =convert(Int,               8280 )
const XPRS_PREDOMROW                  =convert(Int,               8281 )
const XPRS_BRANCHSTRUCTURAL           =convert(Int,               8282 )
const XPRS_QUADRATICUNSHIFT           =convert(Int,               8284 )
const XPRS_BARPRESOLVEOPS             =convert(Int,               8286 )
const XPRS_QSIMPLEXOPS                =convert(Int,               8288 )
const XPRS_CONFLICTCUTS               =convert(Int,               8292 )
const XPRS_CORESPERCPU                =convert(Int,               8296 )
const XPRS_SLEEPONTHREADWAIT          =convert(Int,               8302 )
const XPRS_PREDUPROW                  =convert(Int,               8307 )
const XPRS_CPUPLATFORM                =convert(Int,               8312 )
const XPRS_BARALG                     =convert(Int,               8315 )
const XPRS_TREEPRESOLVE               =convert(Int,               8320 )
const XPRS_TREEPRESOLVE_KEEPBASIS     =convert(Int,               8321 )
const XPRS_TREEPRESOLVEOPS            =convert(Int,               8322 )
const XPRS_LPLOGSTYLE                 =convert(Int,               8326 )
const XPRS_RANDOMSEED                 =convert(Int,               8328 )
const XPRS_TREEQCCUTS                 =convert(Int,               8331 )
const XPRS_PRELINDEP                  =convert(Int,               8333 )
const XPRS_DUALTHREADS                =convert(Int,               8334 )
const XPRS_PREOBJCUTDETECT            =convert(Int,               8336 )
const XPRS_PREBNDREDQUAD              =convert(Int,               8337 )
const XPRS_PREBNDREDCONE              =convert(Int,               8338 )
const XPRS_PRECOMPONENTS              =convert(Int,               8339 )
#/* Integer control parameters that support 64-bit values  */
const XPRS_EXTRAELEMS                 =convert(Int,               8006 )
const XPRS_EXTRAPRESOLVE              =convert(Int,               8037 )
const XPRS_EXTRASETELEMS              =convert(Int,               8191 )

#***************************************************************************\
#* attributes for XPRSprob                                                 *
#***************************************************************************/
#/* String attributes */
const XPRS_MATRIXNAME                  =convert(Int,              3001 )
const XPRS_BOUNDNAME                   =convert(Int,              3002 )
const XPRS_OBJNAME                     =convert(Int,              3003 )
const XPRS_RHSNAME                     =convert(Int,              3004 )
const XPRS_RANGENAME                   =convert(Int,              3005 )
#/* Double attributes */
const XPRS_LPOBJVAL                    =convert(Int,              2001)
const XPRS_SUMPRIMALINF                =convert(Int,              2002)
const XPRS_MIPOBJVAL                   =convert(Int,              2003)
const XPRS_BESTBOUND                   =convert(Int,              2004)
const XPRS_OBJRHS                      =convert(Int,              2005)
const XPRS_MIPBESTOBJVAL               =convert(Int,              2006)
const XPRS_OBJSENSE                    =convert(Int,              2008)
const XPRS_BRANCHVALUE                 =convert(Int,              2009)
const XPRS_PENALTYVALUE                =convert(Int,              2061)
const XPRS_CURRMIPCUTOFF               =convert(Int,              2062)
const XPRS_BARCONDA                    =convert(Int,              2063)
const XPRS_BARCONDD                    =convert(Int,              2064)
const XPRS_BARPRIMALOBJ                =convert(Int,              4001)
const XPRS_BARDUALOBJ                  =convert(Int,              4002)
const XPRS_BARPRIMALINF                =convert(Int,              4003)
const XPRS_BARDUALINF                  =convert(Int,              4004)
const XPRS_BARCGAP                     =convert(Int,              4005)
#/* Integer attributes */
const XPRS_ROWS                        =convert(Int,              1001 )
const XPRS_SETS                        =convert(Int,              1004 )
const XPRS_PRIMALINFEAS                =convert(Int,              1007 )
const XPRS_DUALINFEAS                  =convert(Int,              1008 )
const XPRS_SIMPLEXITER                 =convert(Int,              1009 )
const XPRS_LPSTATUS                    =convert(Int,              1010 )
const XPRS_MIPSTATUS                   =convert(Int,              1011 )
const XPRS_CUTS                        =convert(Int,              1012 )
const XPRS_NODES                       =convert(Int,              1013 )
const XPRS_NODEDEPTH                   =convert(Int,              1014 )
const XPRS_ACTIVENODES                 =convert(Int,              1015 )
const XPRS_MIPSOLNODE                  =convert(Int,              1016 )
const XPRS_MIPSOLS                     =convert(Int,              1017 )
const XPRS_COLS                        =convert(Int,              1018 )
const XPRS_SPAREROWS                   =convert(Int,              1019 )
const XPRS_SPARECOLS                   =convert(Int,              1020 )
const XPRS_SPAREMIPENTS                =convert(Int,              1022 )
const XPRS_ERRORCODE                   =convert(Int,              1023 )
const XPRS_MIPINFEAS                   =convert(Int,              1024 )
const XPRS_PRESOLVESTATE               =convert(Int,              1026 )
const XPRS_PARENTNODE                  =convert(Int,              1027 )
const XPRS_NAMELENGTH                  =convert(Int,              1028 )
const XPRS_QELEMS                      =convert(Int,              1030 )
const XPRS_NUMIIS                      =convert(Int,              1031 )
const XPRS_MIPENTS                     =convert(Int,              1032 )
const XPRS_BRANCHVAR                   =convert(Int,              1036 )
const XPRS_MIPTHREADID                 =convert(Int,              1037 )
const XPRS_ALGORITHM                   =convert(Int,              1049 )
const XPRS_ORIGINALROWS                =convert(Int,              1124 )
const XPRS_ORIGINALQELEMS              =convert(Int,              1157 )
const XPRS_STOPSTATUS                  =convert(Int,              1179 )
const XPRS_ORIGINALMIPENTS             =convert(Int,              1191 )
const XPRS_ORIGINALSETS                =convert(Int,              1194 )
const XPRS_SPARESETS                   =convert(Int,              1203 )
const XPRS_CHECKSONMAXTIME             =convert(Int,              1208 )
const XPRS_CHECKSONMAXCUTTIME          =convert(Int,              1209 )
const XPRS_ORIGINALCOLS                =convert(Int,              1214 )
const XPRS_QCELEMS                     =convert(Int,              1232 )
const XPRS_QCONSTRAINTS                =convert(Int,              1234 )
const XPRS_ORIGINALQCELEMS             =convert(Int,              1237 )
const XPRS_ORIGINALQCONSTRAINTS        =convert(Int,              1239 )
const XPRS_PEAKTOTALTREEMEMORYUSAGE    =convert(Int,              1240 )
const XPRS_CURRENTNODE                 =convert(Int,              1248 )
const XPRS_TREEMEMORYUSAGE             =convert(Int,              1251 )
const XPRS_GLOBALFILESIZE              =convert(Int,              1252 )
const XPRS_GLOBALFILEUSAGE             =convert(Int,              1253 )
const XPRS_INDICATORS                  =convert(Int,              1254 )
const XPRS_ORIGINALINDICATORS          =convert(Int,              1255 )
const XPRS_CORESDETECTED               =convert(Int,              1260 )
const XPRS_BARSING                     =convert(Int,              1281 )
const XPRS_BARSINGR                    =convert(Int,              1282 )
const XPRS_PRESOLVEINDEX               =convert(Int,              1284 )
const XPRS_CONES                       =convert(Int,              1307 )
const XPRS_CONEELEMS                   =convert(Int,              1308 )
const XPRS_BARITER                     =convert(Int,              5001 )
const XPRS_BARAASIZE                   =convert(Int,              5002 )
const XPRS_BARLSIZE                    =convert(Int,              5003 )
const XPRS_BARDENSECOL                 =convert(Int,              5004 )
const XPRS_BARCROSSOVER                =convert(Int,              5005 )
#/* XPRS_IIS has been renamed XPRS_NUMIIS to avoid confusion with the XPRSiis
#   function.  XPRS_IIS is defined here for your convenience. */
const XPRS_IIS = XPRS_NUMIIS
#/* Integer attributes that support 64-bit values */
const XPRS_SETMEMBERS                  =convert(Int,              1005 )
const XPRS_ELEMS                       =convert(Int,              1006 )
const XPRS_SPAREELEMS                  =convert(Int,              1021 )
const XPRS_ORIGINALSETMEMBERS          =convert(Int,              1195 )
const XPRS_SPARESETELEMS               =convert(Int,              1204 )

#/***************************************************************************\
# * control parameters for XPRSmipsolpool                                   *
#\***************************************************************************/
#/* Double control parameters */
const XPRS_MSP_DEFAULTUSERSOLFEASTOL      =convert(Int,           6209 )
const XPRS_MSP_DEFAULTUSERSOLMIPTOL       =convert(Int,           6210 )
const XPRS_MSP_SOL_FEASTOL                =convert(Int,           6402 )
const XPRS_MSP_SOL_MIPTOL                 =convert(Int,           6403 )
#/* Integer control parameters */
const XPRS_MSP_DUPLICATESOLUTIONSPOLICY   =convert(Int,           6203 )
const XPRS_MSP_INCLUDEPROBNAMEINLOGGING   =convert(Int,           6211 )
const XPRS_MSP_WRITESLXSOLLOGGING         =convert(Int,           6212 )
const XPRS_MSP_ENABLESLACKSTORAGE         =convert(Int,           6213 )
const XPRS_MSP_OUTPUTLOG                  =convert(Int,           6214 )
const XPRS_MSP_SOL_BITFIELDSUSR           =convert(Int,           6406 )

#/***************************************************************************\
# * attributes for XPRSmipsolpool                                           *
#\***************************************************************************/
#/* Double attributes */
const XPRS_MSP_SOLPRB_OBJ                 =convert(Int,           6500 )
const XPRS_MSP_SOLPRB_INFSUM_PRIMAL       =convert(Int,           6502 )
const XPRS_MSP_SOLPRB_INFSUM_MIP          =convert(Int,           6504 )
const XPRS_MSP_SOLPRB_INFSUM_SLACK        =convert(Int,           6506 )
const XPRS_MSP_SOLPRB_INFMAX_SLACK        =convert(Int,           6508 )
const XPRS_MSP_SOLPRB_INFSUM_COLUMN       =convert(Int,           6510 )
const XPRS_MSP_SOLPRB_INFMAX_COLUMN       =convert(Int,           6512 )
const XPRS_MSP_SOLPRB_INFSUM_DELAYEDROW   =convert(Int,           6514 )
const XPRS_MSP_SOLPRB_INFMAX_DELAYEDROW   =convert(Int,           6516 )
const XPRS_MSP_SOLPRB_INFSUM_INT          =convert(Int,           6518 )
const XPRS_MSP_SOLPRB_INFMAX_INT          =convert(Int,           6520 )
const XPRS_MSP_SOLPRB_INFSUM_BIN          =convert(Int,           6522 )
const XPRS_MSP_SOLPRB_INFMAX_BIN          =convert(Int,           6524 )
const XPRS_MSP_SOLPRB_INFSUM_SC           =convert(Int,           6526 )
const XPRS_MSP_SOLPRB_INFMAX_SC           =convert(Int,           6528 )
const XPRS_MSP_SOLPRB_INFSUM_SI           =convert(Int,           6530 )
const XPRS_MSP_SOLPRB_INFMAX_SI           =convert(Int,           6532 )
const XPRS_MSP_SOLPRB_INFSUM_PI           =convert(Int,           6534 )
const XPRS_MSP_SOLPRB_INFMAX_PI           =convert(Int,           6536 )
const XPRS_MSP_SOLPRB_INFSUM_SET1         =convert(Int,           6538 )
const XPRS_MSP_SOLPRB_INFMAX_SET1         =convert(Int,           6540 )
const XPRS_MSP_SOLPRB_INFSUM_SET2         =convert(Int,           6542 )
const XPRS_MSP_SOLPRB_INFMAX_SET2         =convert(Int,           6544 )
#/* Integer attributes */
const XPRS_MSP_SOLUTIONS                       =convert(Int,      6208 )
const XPRS_MSP_PRB_VALIDSOLS                   =convert(Int,      6300 )
const XPRS_MSP_PRB_FEASIBLESOLS                =convert(Int,      6301 )
const XPRS_MSP_SOL_COLS                        =convert(Int,      6400 )
const XPRS_MSP_SOL_NONZEROS                    =convert(Int,      6401 )
const XPRS_MSP_SOL_ISUSERSOLUTION              =convert(Int,      6404 )
const XPRS_MSP_SOL_ISREPROCESSEDUSERSOLUTION   =convert(Int,      6405 )
const XPRS_MSP_SOL_BITFIELDSSYS                =convert(Int,      6407 )
const XPRS_MSP_SOLPRB_INFEASCOUNT              =convert(Int,      6501 )
const XPRS_MSP_SOLPRB_INFCNT_PRIMAL            =convert(Int,      6503 )
const XPRS_MSP_SOLPRB_INFCNT_MIP               =convert(Int,      6505 )
const XPRS_MSP_SOLPRB_INFCNT_SLACK             =convert(Int,      6507 )
const XPRS_MSP_SOLPRB_INFMXI_SLACK             =convert(Int,      6509 )
const XPRS_MSP_SOLPRB_INFCNT_COLUMN            =convert(Int,      6511 )
const XPRS_MSP_SOLPRB_INFMXI_COLUMN            =convert(Int,      6513 )
const XPRS_MSP_SOLPRB_INFCNT_DELAYEDROW        =convert(Int,      6515 )
const XPRS_MSP_SOLPRB_INFMXI_DELAYEDROW        =convert(Int,      6517 )
const XPRS_MSP_SOLPRB_INFCNT_INT               =convert(Int,      6519 )
const XPRS_MSP_SOLPRB_INFMXI_INT               =convert(Int,      6521 )
const XPRS_MSP_SOLPRB_INFCNT_BIN               =convert(Int,      6523 )
const XPRS_MSP_SOLPRB_INFMXI_BIN               =convert(Int,      6525 )
const XPRS_MSP_SOLPRB_INFCNT_SC                =convert(Int,      6527 )
const XPRS_MSP_SOLPRB_INFMXI_SC                =convert(Int,      6529 )
const XPRS_MSP_SOLPRB_INFCNT_SI                =convert(Int,      6531 )
const XPRS_MSP_SOLPRB_INFMXI_SI                =convert(Int,      6533 )
const XPRS_MSP_SOLPRB_INFCNT_PI                =convert(Int,      6535 )
const XPRS_MSP_SOLPRB_INFMXI_PI                =convert(Int,      6537 )
const XPRS_MSP_SOLPRB_INFCNT_SET1              =convert(Int,      6539 )
const XPRS_MSP_SOLPRB_INFMXI_SET1              =convert(Int,      6541 )
const XPRS_MSP_SOLPRB_INFCNT_SET2              =convert(Int,      6543 )
const XPRS_MSP_SOLPRB_INFMXI_SET2              =convert(Int,      6545 )

#/***************************************************************************\
# * control parameters for XPRSmipsolenum                                   *
#\***************************************************************************/
#/* Double control parameters */
const XPRS_MSE_OUTPUTTOL                       =convert(Int,      6609 )
#/* Integer control parameters */
const XPRS_MSE_CALLBACKCULLSOLS_MIPOBJECT      =convert(Int,      6601 )
const XPRS_MSE_CALLBACKCULLSOLS_DIVERSITY      =convert(Int,      6602 )
const XPRS_MSE_CALLBACKCULLSOLS_MODOBJECT      =convert(Int,      6603 )
const XPRS_MSE_OPTIMIZEDIVERSITY               =convert(Int,      6607 )
const XPRS_MSE_OUTPUTLOG                       =convert(Int,      6610 )

#/***************************************************************************\
# * attributes for XPRSmipsolenum                                           *
#\***************************************************************************/
#/* Double attributes */
const XPRS_MSE_DIVERSITYSUM                    =convert(Int,      6608 )
#/* Integer attributes */
const XPRS_MSE_SOLUTIONS                       =convert(Int,      6600 )
const XPRS_MSE_METRIC_MIPOBJECT                =convert(Int,      6604 )
const XPRS_MSE_METRIC_DIVERSITY                =convert(Int,      6605 )
const XPRS_MSE_METRIC_MODOBJECT                =convert(Int,      6606 )

#/***************************************************************************\
# * control parameters for XPRSprobperturber                                *
#\***************************************************************************/
#/* Double control parameters */
const XPRS_PTB_PERMUTE_INTENSITY_ROW                    =convert(Int, 6702 )
const XPRS_PTB_PERMUTE_INTENSITY_COL                    =convert(Int, 6703 )
const XPRS_PTB_SHIFTSCALE_COLS_INTENSITY                =convert(Int, 6722 )
const XPRS_PTB_SHIFTSCALE_COLS_MAXRANGEFORCOMPLEMENTING =convert(Int, 6729 )
const XPRS_PTB_SHIFTSCALE_ROWS_INTENSITY                =convert(Int, 6762 )
#/* Integer control parameters */
const XPRS_PTB_PERMUTE_ACTIVE                           =convert(Int, 6700 )
const XPRS_PTB_PERMUTE_SEEDLAST                         =convert(Int, 6701 )
const XPRS_PTB_PERTURB_COST2_ACTIVE                     =convert(Int, 6710 )
const XPRS_PTB_PERTURB_COST2_SEEDLAST                   =convert(Int, 6711 )
const XPRS_PTB_SHIFTSCALE_COLS_ACTIVE                   =convert(Int, 6720 )
const XPRS_PTB_SHIFTSCALE_COLS_SEEDLAST                 =convert(Int, 6721 )
const XPRS_PTB_SHIFTSCALE_COLS_SHIFT_ACTIVE_I           =convert(Int, 6725 )
const XPRS_PTB_SHIFTSCALE_COLS_NEGATE_ACTIVE_I          =convert(Int, 6726 )
const XPRS_PTB_SHIFTSCALE_COLS_COMPLEMENT_ACTIVE_I      =convert(Int, 6727 )
const XPRS_PTB_SHIFTSCALE_COLS_COMPLEMENT_ACTIVE_B      =convert(Int, 6728 )
const XPRS_PTB_SHIFTSCALE_ROWS_ACTIVE                   =convert(Int, 6760 )
const XPRS_PTB_SHIFTSCALE_ROWS_SEEDLAST                 =convert(Int, 6761 )

#/***************************************************************************\
# * attributes for XPRSprobperturber                                        *
#\***************************************************************************/
#/* Double attributes */
const XPRS_PTB_PERTURB_COST2_TOTALABSCOSTCHANGE        =convert(Int,  6713 )
const XPRS_PTB_SHIFTSCALE_COLS_FIXEDOBJDELTA           =convert(Int,  6724 )
#/* Integer attributes */
const XPRS_PTB_PERMUTE_PERMCOUNT_ROW                   =convert(Int,  6704 )
const XPRS_PTB_PERMUTE_PERMCOUNT_COL                   =convert(Int,  6705 )
const XPRS_PTB_PERTURB_COST2_CHANGEDCOLCOUNT           =convert(Int,  6712 )
const XPRS_PTB_SHIFTSCALE_COLS_CHANGEDCOLCOUNT         =convert(Int,  6723 )

#/***************************************************************************\
# * values related to LPSTATUS                                              *
#\***************************************************************************/
const XPRS_LP_UNSTARTED         =convert(Int, 0 )
const XPRS_LP_OPTIMAL           =convert(Int, 1 )
const XPRS_LP_INFEAS            =convert(Int, 2 )
const XPRS_LP_CUTOFF            =convert(Int, 3 )
const XPRS_LP_UNFINISHED        =convert(Int, 4 )
const XPRS_LP_UNBOUNDED         =convert(Int, 5 )
const XPRS_LP_CUTOFF_IN_DUAL    =convert(Int, 6 )
const XPRS_LP_UNSOLVED          =convert(Int, 7 )
const XPRS_LP_NONCONVEX         =convert(Int, 8 )

#/***************************************************************************\
# * values related to MIPSTATUS                                             *
#\***************************************************************************/
const XPRS_MIP_NOT_LOADED       =convert(Int, 0 )
const XPRS_MIP_LP_NOT_OPTIMAL   =convert(Int, 1 )
const XPRS_MIP_LP_OPTIMAL       =convert(Int, 2 )
const XPRS_MIP_NO_SOL_FOUND     =convert(Int, 3 )
const XPRS_MIP_SOLUTION         =convert(Int, 4 )
const XPRS_MIP_INFEAS           =convert(Int, 5 )
const XPRS_MIP_OPTIMAL          =convert(Int, 6 )
const XPRS_MIP_UNBOUNDED        =convert(Int, 7 )

#/***************************************************************************\
# * values related to BARORDER                                              *
#\***************************************************************************/
const XPRS_BAR_DEFAULT            =convert(Int, 0 )
const XPRS_BAR_MIN_DEGREE         =convert(Int, 1 )
const XPRS_BAR_MIN_LOCAL_FILL     =convert(Int, 2 )
const XPRS_BAR_NESTED_DISSECTION  =convert(Int, 3 )

#/***************************************************************************\
# * values related to DEFAULTALG                                            *
#\***************************************************************************/
const XPRS_ALG_DEFAULT            =convert(Int, 1 )
const XPRS_ALG_DUAL               =convert(Int, 2 )
const XPRS_ALG_PRIMAL             =convert(Int, 3 )
const XPRS_ALG_BARRIER            =convert(Int, 4 )
const XPRS_ALG_NETWORK            =convert(Int, 5 )

#/***************************************************************************\
# * values related to XPRSinterrupt                                         *
#\***************************************************************************/
const XPRS_STOP_NONE                    =convert(Int, 0)
const XPRS_STOP_TIMELIMIT               =convert(Int, 1)
const XPRS_STOP_CTRLC                   =convert(Int, 2)
const XPRS_STOP_NODELIMIT               =convert(Int, 3)
const XPRS_STOP_ITERLIMIT               =convert(Int, 4)
const XPRS_STOP_MIPGAP                  =convert(Int, 5)
const XPRS_STOP_SOLLIMIT                =convert(Int, 6)
const XPRS_STOP_USER                    =convert(Int, 9)

#/***************************************************************************\
# * values related to AlwaysNeverOrAutomatic                                  *
#\***************************************************************************/
const XPRS_ANA_AUTOMATIC               =convert(Int, -1)
const XPRS_ANA_NEVER                   =convert(Int, 0)
const XPRS_ANA_ALWAYS                  =convert(Int, 1)

#/***************************************************************************\
# * values related to OnOrOff                                               *
#\***************************************************************************/
const XPRS_BOOL_OFF                     =convert(Int, 0)
const XPRS_BOOL_ON                      =convert(Int, 1)

#/***************************************************************************\
# * values related to BACKTRACK                                             *
#\***************************************************************************/
const XPRS_BACKTRACKALG_BEST_ESTIMATE            =convert(Int,2)
const XPRS_BACKTRACKALG_BEST_BOUND               =convert(Int,3)
const XPRS_BACKTRACKALG_DEEPEST_NODE             =convert(Int,4)
const XPRS_BACKTRACKALG_HIGHEST_NODE             =convert(Int,5)
const XPRS_BACKTRACKALG_EARLIEST_NODE            =convert(Int,6)
const XPRS_BACKTRACKALG_LATEST_NODE              =convert(Int,7)
const XPRS_BACKTRACKALG_RANDOM                   =convert(Int,8)
const XPRS_BACKTRACKALG_MIN_INFEAS               =convert(Int,9)
const XPRS_BACKTRACKALG_BEST_ESTIMATE_MIN_INFEAS =convert(Int,10)
const XPRS_BACKTRACKALG_DEEPEST_BEST_ESTIMATE    =convert(Int,11)

#/***************************************************************************\
# * values related to BRANCHCHOICE                                          *
#\***************************************************************************/
const XPRS_BRANCH_MIN_EST_FIRST            =convert(Int,0)
const XPRS_BRANCH_MAX_EST_FIRST            =convert(Int,1)

#/***************************************************************************\
# * values related to CHOLESKYALG                                           *
#\***************************************************************************/
const XPRS_ALG_PULL_CHOLESKY           =convert(Int,0)
const XPRS_ALG_PUSH_CHOLESKY           =convert(Int,1)

#/***************************************************************************\
# * values related to CROSSOVERDRP                                          *
#\***************************************************************************/
const XPRS_XDRPBEFORE_CROSSOVER        =convert(Int,1)
const XPRS_XDRPINSIDE_CROSSOVER        =convert(Int,2)
const XPRS_XDRPAGGRESSIVE_BEFORE_CROSSOVER =convert(Int,4)

#/***************************************************************************\
# * values related to DUALGRADIENT                                          *
#\***************************************************************************/
const XPRS_DUALGRADIENT_AUTOMATIC               =convert(Int, -1)
const XPRS_DUALGRADIENT_DEVEX                   =convert(Int, 0)
const XPRS_DUALGRADIENT_STEEPESTEDGE            =convert(Int, 1)

#/***************************************************************************\
# * values related to DUALSTRATEGY                                          *
#\***************************************************************************/
const XPRS_DUALSTRATEGY_REMOVE_INFEAS_WITH_PRIMAL=convert(Int, 0)
const XPRS_DUALSTRATEGY_REMOVE_INFEAS_WITH_DUAL  =convert(Int,1)

#/***************************************************************************\
# * values related to FEASIBILITYPUMP                                       *
#\***************************************************************************/
const XPRS_FEASIBILITYPUMP_NEVER                   =convert(Int, 0)
const XPRS_FEASIBILITYPUMP_ALWAYS                  =convert(Int, 1)
const XPRS_FEASIBILITYPUMP_LASTRESORT              =convert(Int, 2)

#/***************************************************************************\
# * values related to HEURSEARCHSELECT                                      *
#\***************************************************************************/
const XPRS_HEURSEARCH_LOCAL_SEARCH_LARGE_NEIGHBOURHOOD =convert(Int,0)
const XPRS_HEURSEARCH_LOCAL_SEARCH_NODE_NEIGHBOURHOOD =convert(Int,1)
const XPRS_HEURSEARCH_LOCAL_SEARCH_SOLUTION_NEIGHBOURHOOD =convert(Int,2)

#/***************************************************************************\
# * values related to HEURSTRATEGY                                          *
#\***************************************************************************/
const XPRS_HEURSTRATEGY_AUTOMATIC             =convert(Int,  -1)
const XPRS_HEURSTRATEGY_NONE                  =convert(Int,  0)
const XPRS_HEURSTRATEGY_BASIC                 =convert(Int,  1)
const XPRS_HEURSTRATEGY_ENHANCED              =convert(Int,  2)
const XPRS_HEURSTRATEGY_EXTENSIVE             =convert(Int,  3)

#/***************************************************************************\
# * values related to NODESELECTION                                         *
#\***************************************************************************/
const XPRS_NODESELECTION_LOCAL_FIRST             =convert(Int,1)
const XPRS_NODESELECTION_BEST_FIRST              =convert(Int,2)
const XPRS_NODESELECTION_LOCAL_DEPTH_FIRST       =convert(Int,3)
const XPRS_NODESELECTION_BEST_FIRST_THEN_LOCAL_FIRST =convert(Int,4)
const XPRS_NODESELECTION_DEPTH_FIRST             =convert(Int, 5)

#/***************************************************************************\
# * values related to OUTPUTLOG                                             *
#\***************************************************************************/
const XPRS_OUTPUTLOG_NO_OUTPUT                =convert(Int,0)
const XPRS_OUTPUTLOG_FULL_OUTPUT              =convert(Int,1)
const XPRS_OUTPUTLOG_ERRORS_AND_WARNINGS      =convert(Int,2)
const XPRS_OUTPUTLOG_ERRORS                   =convert(Int,3)

#/***************************************************************************\
# * values related to PREPROBING                                            *
#\***************************************************************************/
const XPRS_PREPROBING_AUTOMATIC               =convert(Int, -1)
const XPRS_PREPROBING_DISABLED                =convert(Int, 0)
const XPRS_PREPROBING_LIGHT                   =convert(Int, 1)
const XPRS_PREPROBING_FULL                    =convert(Int, 2)
const XPRS_PREPROBING_FULL_AND_REPEAT         =convert(Int, 3)

#/***************************************************************************\
# * values related to PRESOLVEOPS                                           *
#\***************************************************************************/
const XPRS_PRESOLVEOPS_SINGLETONCOLUMNREMOVAL  =convert(Int, 1)
const XPRS_PRESOLVEOPS_SINGLETONROWREMOVAL     =convert(Int, 2)
const XPRS_PRESOLVEOPS_FORCINGROWREMOVAL       =convert(Int, 4)
const XPRS_PRESOLVEOPS_DUALREDUCTIONS          =convert(Int, 8)
const XPRS_PRESOLVEOPS_REDUNDANTROWREMOVAL     =convert(Int, 16)
const XPRS_PRESOLVEOPS_DUPLICATECOLUMNREMOVAL  =convert(Int, 32)
const XPRS_PRESOLVEOPS_DUPLICATEROWREMOVAL     =convert(Int, 64)
const XPRS_PRESOLVEOPS_STRONGDUALREDUCTIONS    =convert(Int, 128)
const XPRS_PRESOLVEOPS_VARIABLEELIMINATIONS    =convert(Int, 256)
const XPRS_PRESOLVEOPS_NOIPREDUCTIONS          =convert(Int, 512)
const XPRS_PRESOLVEOPS_NOADVANCEDIPREDUCTIONS  =convert(Int, 2048)
const XPRS_PRESOLVEOPS_LINEARLYDEPENDANTROWREMOVAL =convert(Int,16384)
const XPRS_PRESOLVEOPS_NOINTEGERVARIABLEANDSOSDETECTION =convert(Int,32768)

#/***************************************************************************\
# * values related to PRESOLVESTATE                                         *
#\***************************************************************************/
#const XPRS_PRESOLVESTATE_PROBLEMLOADED            (1<<0)
#const XPRS_PRESOLVESTATE_PROBLEMLPPRESOLVED       (1<<1)
#const XPRS_PRESOLVESTATE_PROBLEMMIPPRESOLVED      (1<<2)
#const XPRS_PRESOLVESTATE_SOLUTIONVALID            (1<<7)

#/***************************************************************************\
# * values related to MIPPRESOLVE                                           *
#\***************************************************************************/
const XPRS_MIPPRESOLVE_REDUCED_COST_FIXING      =convert(Int,1)
const XPRS_MIPPRESOLVE_LOGIC_PREPROCESSING      =convert(Int,2)
const XPRS_MIPPRESOLVE_ALLOW_CHANGE_BOUNDS      =convert(Int,8)

#/***************************************************************************\
# * values related to PRESOLVE                                              *
#\***************************************************************************/
const XPRS_PRESOLVE_NOPRIMALINFEASIBILITY   =convert(Int, -1)
const XPRS_PRESOLVE_NONE                    =convert(Int, 0)
const XPRS_PRESOLVE_DEFAULT                 =convert(Int, 1)
const XPRS_PRESOLVE_KEEPREDUNDANTBOUNDS     =convert(Int, 2)

#/***************************************************************************\
# * values related to PRICINGALG                                            *
#\***************************************************************************/
const XPRS_PRICING_PARTIAL                 =convert(Int, -1)
const XPRS_PRICING_DEFAULT                 =convert(Int, 0)
const XPRS_PRICING_DEVEX                   =convert(Int, 1)

#/***************************************************************************\
# * values related to CUTSTRATEGY                                           *
#\***************************************************************************/
const XPRS_CUTSTRATEGY_DEFAULT                 =convert(Int, -1)
const XPRS_CUTSTRATEGY_NONE                    =convert(Int, 0)
const XPRS_CUTSTRATEGY_CONSERVATIVE            =convert(Int, 1)
const XPRS_CUTSTRATEGY_MODERATE                =convert(Int, 2)
const XPRS_CUTSTRATEGY_AGGRESSIVE              =convert(Int, 3)

#/***************************************************************************\
# * values related to VARSELECTION                                          *
#\***************************************************************************/
const XPRS_VARSELECTION_AUTOMATIC               =convert(Int, -1)
const XPRS_VARSELECTION_MIN_UPDOWN_PSEUDO_COSTS =convert(Int, 1)
const XPRS_VARSELECTION_SUM_UPDOWN_PSEUDO_COSTS =convert(Int, 2)
const XPRS_VARSELECTION_MAX_UPDOWN_PSEUDO_COSTS_PLUS_TWICE_MIN =convert(Int,3)
const XPRS_VARSELECTION_MAX_UPDOWN_PSEUDO_COSTS  =convert(Int,4)
const XPRS_VARSELECTION_DOWN_PSEUDO_COST         =convert(Int,5)
const XPRS_VARSELECTION_UP_PSEUDO_COST           =convert(Int,6)

#/***************************************************************************\
# * values related to SCALING                                               *
#\***************************************************************************/
const XPRS_SCALING_ROW_SCALING             =convert(Int, 1)
const XPRS_SCALING_COLUMN_SCALING          =convert(Int, 2)
const XPRS_SCALING_ROW_SCALING_AGAIN       =convert(Int, 4)
const XPRS_SCALING_MAXIMUM                 =convert(Int, 8)
const XPRS_SCALING_CURTIS_REID             =convert(Int, 16)
const XPRS_SCALING_BY_MAX_ELEM_NOT_GEO_MEAN=convert(Int, 32)
const XPRS_SCALING_OBJECTIVE_SCALING       =convert(Int, 64)
const XPRS_SCALING_EXCLUDE_QUADRATIC_FROM_SCALE_FACTOR =convert(Int,128)
const XPRS_SCALING_IGNORE_QUADRATIC_ROW_PART=convert(Int, 256)
const XPRS_SCALING_BEFORE_PRESOLVE          =convert(Int,512)
const XPRS_SCALING_NO_SCALING_ROWS_UP       =convert(Int,1024)
const XPRS_SCALING_NO_SCALING_COLUMNS_DOWN  =convert(Int,2048)
const XPRS_SCALING_SIMPLEX_OBJECTIVE_SCALING=convert(Int, 4096)
const XPRS_SCALING_RHS_SCALING              =convert(Int,8192)
const XPRS_SCALING_NO_AGGRESSIVE_Q_SCALING  =convert(Int,16384)
const XPRS_SCALING_SLACK_SCALING            =convert(Int,32768)

#/***************************************************************************\
# * values related to CUTSELECT                                             *
#\***************************************************************************/
const XPRS_CUTSELECT_CLIQUE               =convert(Int,    (32+1823)    )
const XPRS_CUTSELECT_MIR                  =convert(Int,    (64+1823)    )
const XPRS_CUTSELECT_COVER                =convert(Int,    (128+1823)   )
const XPRS_CUTSELECT_FLOWPATH             =convert(Int,    (2048+1823)  )
const XPRS_CUTSELECT_IMPLICATION          =convert(Int,    (4096+1823)  )
const XPRS_CUTSELECT_LIFT_AND_PROJECT     =convert(Int,    (8192+1823)  )
const XPRS_CUTSELECT_DISABLE_CUT_ROWS     =convert(Int,    (16384+1823) )
const XPRS_CUTSELECT_GUB_COVER            =convert(Int,    (32768+1823) )
const XPRS_CUTSELECT_DEFAULT              =convert(Int,    (-1)         )

#/***************************************************************************\
# * values related to REFINEOPS                                             *
#\***************************************************************************/
const XPRS_REFINEOPS_LPOPTIMAL              =convert(Int,  1)
const XPRS_REFINEOPS_MIPSOLUTION            =convert(Int,  2)
const XPRS_REFINEOPS_MIPOPTIMAL             =convert(Int,  4)
const XPRS_REFINEOPS_MIPNODELP              =convert(Int,  8)

#/***************************************************************************\
# * values related to DUALIZEOPS                                            *
#\***************************************************************************/
const XPRS_DUALIZEOPS_SWITCHALGORITHM          =convert(Int,1)

#/***************************************************************************\
# * values related to TREEDIAGNOSTICS                                       *
#\***************************************************************************/
const XPRS_TREEDIAGNOSTICS_MEMORY_USAGE_SUMMARIES  =convert(Int,1)
const XPRS_TREEDIAGNOSTICS_MEMORY_SAVED_REPORTS    =convert(Int,2)

#/***************************************************************************\
# * values related to BARPRESOLVEOPS                                        *
#\***************************************************************************/
const XPRS_BARPRESOLVEOPS_STANDARD_PRESOLVE        =convert(Int,0)
const XPRS_BARPRESOLVEOPS_EXTRA_BARRIER_PRESOLVE   =convert(Int,1)

#/***************************************************************************\
# * values related to PRECOEFELIM                                           *
#\***************************************************************************/
const XPRS_PRECOEFELIM_DISABLED               =convert(Int, 0 )
const XPRS_PRECOEFELIM_AGGRESSIVE             =convert(Int, 1 )
const XPRS_PRECOEFELIM_CAUTIOUS               =convert(Int, 2 )

#/***************************************************************************\
# * values related to PREDOMROW                                             *
#\***************************************************************************/
const XPRS_PREDOMROW_AUTOMATIC               =convert(Int, -1)
const XPRS_PREDOMROW_DISABLED                =convert(Int, 0)
const XPRS_PREDOMROW_CAUTIOUS                =convert(Int, 1)
const XPRS_PREDOMROW_MEDIUM                  =convert(Int, 2)
const XPRS_PREDOMROW_AGGRESSIVE              =convert(Int, 3)

#/***************************************************************************\
# * values related to PREDOMCOL                                             *
#\***************************************************************************/
const XPRS_PREDOMCOL_AUTOMATIC               =convert(Int, -1)
const XPRS_PREDOMCOL_DISABLED                =convert(Int, 0)
const XPRS_PREDOMCOL_CAUTIOUS                =convert(Int, 1)
const XPRS_PREDOMCOL_AGGRESSIVE              =convert(Int, 2)

#/***************************************************************************\
# * values related to PRIMALUNSHIFT                                         *
#\***************************************************************************/
const XPRS_PRIMALUNSHIFT_ALLOW_DUAL_UNSHIFT      =convert(Int, 0)
const XPRS_PRIMALUNSHIFT_NO_DUAL_UNSHIFT         =convert(Int, 1)

#/***************************************************************************\
# * values related to REPAIRINDEFINITEQ                                     *
#\***************************************************************************/
const XPRS_REPAIRINDEFINITEQ_REPAIR_IF_POSSIBLE     =convert(Int,  0)
const XPRS_REPAIRINDEFINITEQ_NO_REPAIR              =convert(Int,  1)

#/***************************************************************************\
# * values related to Minimize/Maximize                                     *
#\***************************************************************************/
const XPRS_OBJ_MINIMIZE              =convert(Int,  1)
const XPRS_OBJ_MAXIMIZE              =convert(Int,  -1)

#/***************************************************************************\
# * values related to Set/GetControl/Attribinfo                                  *
#\***************************************************************************/
const XPRS_TYPE_NOTDEFINED               =convert(Int, 0)
const XPRS_TYPE_INT                      =convert(Int, 1)
const XPRS_TYPE_INT64                    =convert(Int, 2)
const XPRS_TYPE_DOUBLE                   =convert(Int, 3)
const XPRS_TYPE_STRING                   =convert(Int, 4)

#/***************************************************************************\
# * values related to QCONVEXITY                                            *
#\***************************************************************************/
const XPRS_QCONVEXITY_UNKNOWN              =convert(Int,    -1 )
const XPRS_QCONVEXITY_NONCONVEX            =convert(Int,    0 )
const XPRS_QCONVEXITY_CONVEX               =convert(Int,    1 )
const XPRS_QCONVEXITY_REPAIRABLE           =convert(Int,    2 )
const XPRS_QCONVEXITY_CONVEXCONE           =convert(Int,    3 )
const XPRS_QCONVEXITY_CONECONVERTABLE      =convert(Int,    4 )


#/****************************************************************************\
# * values of bit flags for MipSolPool Solution                              *
#\****************************************************************************/
#const XPRS_ISUSERSOLUTION                 0x1
#const XPRS_ISREPROCESSEDUSERSOLUTION      0x2


# CONTROLS LISTS
const XPRS_STR_CONTROLS = [
6001,
6002,
6003,
6004,
6005
]

const XPRS_DBL_CONTROLS = [
7001,
7002,
7003,
7004,
7005,
7006,
7007,
7008,
7009,
7012,
7013,
7014,
7015,
7016,
7018,
7019,
7020,
7023,
7032,
7033,
7034,
7035,
7036,
7042,
7044,
7047,
7064,
7065,
7069,
7071,
7073,
7086,
7089,
7090,
7091,
7097,
7099,
7100,
7101,
7102,
7105,
7108,
7109,
7110,
7112,
7113,
7114,
7116,
7121,
7122
]

const XPRS_INT_CONTROLS = [
8004,
8005,
8007,
8009,
8010,
8011,
8012,
8013,
8014,
8015,
8018,
8020,
8021,
8023,
8025,
8026,
8027,
8028,
8030,
8032,
8034,
8035,
8038,
8043,
8044,
8045,
8046,
8047,
8050,
8051,
8052,
8053,
8054,
8061,
8068,
8071,
8077,
8078,
8079,
8080,
8082,
8084,
8086,
8090,
8091,
8093,
8094,
8097,
8112,
8116,
8117,
8118,
8124,
8125,
8126,
8127,
8129,
8130,
8131,
8133,
8134,
8135,
8137,
8138,
8139,
8140,
8141,
8142,
8143,
8144,
8145,
8146,
8147,
8149,
8152,
8153,
8154,
8155,
8156,
8157,
8158,
8160,
8161,
8162,
8163,
8164,
8170,
8171,
8174,
8175,
8177,
8178,
8180,
8186,
8190,
8193,
8194,
8195,
8196,
8197,
8198,
8202,
8203,
8204,
8206,
8208,
8209,
8210,
8211,
8215,
8216,
8217,
8223,
8224,
8227,
8229,
8232,
8238,
8240,
8241,
8242,
8243,
8244,
8245,
8250,
8251,
8252,
8254,
8257,
8266,
8267,
8270,
8274,
8275,
8276,
8278,
8280,
8281,
8282,
8284,
8286,
8288,
8292,
8296,
8302,
8307,
8312,
8315,
8320,
8321,
8322,
8326,
8328,
8331,
8333,
8334,
8336,
8337,
8338,
8339
]
XPRS_CONTROLS_DICT = Dict(
:MPSRHSNAME                => XPRS_MPSRHSNAME               ,      
:MPSOBJNAME                => XPRS_MPSOBJNAME               ,      
:MPSRANGENAME              => XPRS_MPSRANGENAME             ,         
:MPSBOUNDNAME              => XPRS_MPSBOUNDNAME             ,         
:OUTPUTMASK                => XPRS_OUTPUTMASK               ,       
#:#control parameters */    => XPRS_#control parameters */   ,                                   
:MATRIXTOL                 => XPRS_MATRIXTOL                ,     
:PIVOTTOL                  => XPRS_PIVOTTOL                 ,   
:FEASTOL                   => XPRS_FEASTOL                  ,      
:OUTPUTTOL                 => XPRS_OUTPUTTOL                ,      
:SOSREFTOL                 => XPRS_SOSREFTOL                , 
:OPTIMALITYTOL             => XPRS_OPTIMALITYTOL            , 
:ETATOL                    => XPRS_ETATOL                   , 
:RELPIVOTTOL               => XPRS_RELPIVOTTOL              , 
:MIPTOL                    => XPRS_MIPTOL                   , 
:MIPADDCUTOFF              => XPRS_MIPADDCUTOFF             , 
:MIPABSCUTOFF              => XPRS_MIPABSCUTOFF             , 
:MIPRELCUTOFF              => XPRS_MIPRELCUTOFF             , 
:PSEUDOCOST                => XPRS_PSEUDOCOST               , 
:PENALTY                   => XPRS_PENALTY                  , 
:BIGM                      => XPRS_BIGM                     , 
:MIPABSSTOP                => XPRS_MIPABSSTOP               , 
:MIPRELSTOP                => XPRS_MIPRELSTOP               , 
:CROSSOVERACCURACYTOL      => XPRS_CROSSOVERACCURACYTOL     , 
:CHOLESKYTOL               => XPRS_CHOLESKYTOL              , 
:BARGAPSTOP                => XPRS_BARGAPSTOP               , 
:BARDUALSTOP               => XPRS_BARDUALSTOP              , 
:BARPRIMALSTOP             => XPRS_BARPRIMALSTOP            , 
:BARSTEPSTOP               => XPRS_BARSTEPSTOP              , 
:ELIMTOL                   => XPRS_ELIMTOL                  , 
:PERTURB                   => XPRS_PERTURB                  , 
:MARKOWITZTOL              => XPRS_MARKOWITZTOL             , 
:MIPABSGAPNOTIFY           => XPRS_MIPABSGAPNOTIFY          , 
:MIPRELGAPNOTIFY           => XPRS_MIPRELGAPNOTIFY          , 
:PPFACTOR                  => XPRS_PPFACTOR                 , 
:REPAIRINDEFINITEQMAX      => XPRS_REPAIRINDEFINITEQMAX     , 
:BARGAPTARGET              => XPRS_BARGAPTARGET             , 
:SBEFFORT                  => XPRS_SBEFFORT                 , 
:HEURDIVERANDOMIZE         => XPRS_HEURDIVERANDOMIZE        , 
:HEURSEARCHEFFORT          => XPRS_HEURSEARCHEFFORT         , 
:CUTFACTOR                 => XPRS_CUTFACTOR                , 
:EIGENVALUETOL             => XPRS_EIGENVALUETOL            , 
:INDLINBIGM                => XPRS_INDLINBIGM               , 
:TREEMEMORYSAVINGTARGET    => XPRS_TREEMEMORYSAVINGTARGET   , 
:GLOBALFILEBIAS            => XPRS_GLOBALFILEBIAS           , 
:INDPRELINBIGM             => XPRS_INDPRELINBIGM            , 
:RELAXTREEMEMORYLIMIT      => XPRS_RELAXTREEMEMORYLIMIT     , 
:MIPABSGAPNOTIFYOBJ        => XPRS_MIPABSGAPNOTIFYOBJ       , 
:MIPABSGAPNOTIFYBOUND      => XPRS_MIPABSGAPNOTIFYBOUND     , 
:PRESOLVEMAXGROW           => XPRS_PRESOLVEMAXGROW          , 
:HEURSEARCHTARGETSIZE      => XPRS_HEURSEARCHTARGETSIZE     , 
:CROSSOVERRELPIVOTTOL      => XPRS_CROSSOVERRELPIVOTTOL     , 
:CROSSOVERRELPIVOTTOLSAFE  => XPRS_CROSSOVERRELPIVOTTOLSAFE , 
:DETLOGFREQ                => XPRS_DETLOGFREQ               , 
:FEASTOLTARGET             => XPRS_FEASTOLTARGET            , 
:OPTIMALITYTOLTARGET       => XPRS_OPTIMALITYTOLTARGET      , 
#: #control parameters */   => XPRS_ #control parameters */  ,        
:EXTRAROWS                 => XPRS_EXTRAROWS                , 
:EXTRACOLS                 => XPRS_EXTRACOLS                , 
:LPITERLIMIT               => XPRS_LPITERLIMIT              , 
:LPLOG                     => XPRS_LPLOG                    , 
:SCALING                   => XPRS_SCALING                  , 
:PRESOLVE                  => XPRS_PRESOLVE                 , 
:CRASH                     => XPRS_CRASH                    , 
:PRICINGALG                => XPRS_PRICINGALG               , 
:INVERTFREQ                => XPRS_INVERTFREQ               , 
:INVERTMIN                 => XPRS_INVERTMIN                , 
:MAXNODE                   => XPRS_MAXNODE                  , 
:MAXTIME                   => XPRS_MAXTIME                  , 
:MAXMIPSOL                 => XPRS_MAXMIPSOL                , 
:DEFAULTALG                => XPRS_DEFAULTALG               , 
:VARSELECTION              => XPRS_VARSELECTION             , 
:NODESELECTION             => XPRS_NODESELECTION            , 
:BACKTRACK                 => XPRS_BACKTRACK                , 
:MIPLOG                    => XPRS_MIPLOG                   , 
:KEEPNROWS                 => XPRS_KEEPNROWS                , 
:MPSECHO                   => XPRS_MPSECHO                  , 
:MAXPAGELINES              => XPRS_MAXPAGELINES             , 
:OUTPUTLOG                 => XPRS_OUTPUTLOG                , 
:BARSOLUTION               => XPRS_BARSOLUTION              , 
:CACHESIZE                 => XPRS_CACHESIZE                , 
:CROSSOVER                 => XPRS_CROSSOVER                , 
:BARITERLIMIT              => XPRS_BARITERLIMIT             , 
:CHOLESKYALG               => XPRS_CHOLESKYALG              , 
:BAROUTPUT                 => XPRS_BAROUTPUT                , 
:CSTYLE                    => XPRS_CSTYLE                   , 
:EXTRAMIPENTS              => XPRS_EXTRAMIPENTS             , 
:REFACTOR                  => XPRS_REFACTOR                 , 
:BARTHREADS                => XPRS_BARTHREADS               , 
:KEEPBASIS                 => XPRS_KEEPBASIS                , 
:VERSION                   => XPRS_VERSION                  , 
:BIGMMETHOD                => XPRS_BIGMMETHOD               , 
:MPSNAMELENGTH             => XPRS_MPSNAMELENGTH            , 
:PRESOLVEOPS               => XPRS_PRESOLVEOPS              , 
:MIPPRESOLVE               => XPRS_MIPPRESOLVE              , 
:MIPTHREADS                => XPRS_MIPTHREADS               , 
:BARORDER                  => XPRS_BARORDER                 , 
:BREADTHFIRST              => XPRS_BREADTHFIRST             , 
:AUTOPERTURB               => XPRS_AUTOPERTURB              , 
:DENSECOLLIMIT             => XPRS_DENSECOLLIMIT            , 
:CALLBACKFROMMASTERTHREAD  => XPRS_CALLBACKFROMMASTERTHREAD , 
:MAXMCOEFFBUFFERELEMS      => XPRS_MAXMCOEFFBUFFERELEMS     , 
:REFINEOPS                 => XPRS_REFINEOPS                , 
:LPREFINEITERLIMIT         => XPRS_LPREFINEITERLIMIT        , 
:DUALIZEOPS                => XPRS_DUALIZEOPS               , 
:MAXMEMORY                 => XPRS_MAXMEMORY                , 
:CUTFREQ                   => XPRS_CUTFREQ                  , 
:SYMSELECT                 => XPRS_SYMSELECT                , 
:SYMMETRY                  => XPRS_SYMMETRY                 , 
:LPTHREADS                 => XPRS_LPTHREADS                , 
:MIQCPALG                  => XPRS_MIQCPALG                 , 
:QCCUTS                    => XPRS_QCCUTS                   , 
:QCROOTALG                 => XPRS_QCROOTALG                , 
:ALGAFTERNETWORK           => XPRS_ALGAFTERNETWORK          , 
:TRACE                     => XPRS_TRACE                    , 
:MAXIIS                    => XPRS_MAXIIS                   , 
:CPUTIME                   => XPRS_CPUTIME                  , 
:COVERCUTS                 => XPRS_COVERCUTS                , 
:GOMCUTS                   => XPRS_GOMCUTS                  , 
:MPSFORMAT                 => XPRS_MPSFORMAT                , 
:CUTSTRATEGY               => XPRS_CUTSTRATEGY              , 
:CUTDEPTH                  => XPRS_CUTDEPTH                 , 
:TREECOVERCUTS             => XPRS_TREECOVERCUTS            , 
:TREEGOMCUTS               => XPRS_TREEGOMCUTS              , 
:CUTSELECT                 => XPRS_CUTSELECT                , 
:TREECUTSELECT             => XPRS_TREECUTSELECT            , 
:DUALIZE                   => XPRS_DUALIZE                  , 
:DUALGRADIENT              => XPRS_DUALGRADIENT             , 
:SBITERLIMIT               => XPRS_SBITERLIMIT              , 
:SBBEST                    => XPRS_SBBEST                   , 
:MAXCUTTIME                => XPRS_MAXCUTTIME               , 
:ACTIVESET                 => XPRS_ACTIVESET                , 
:BARINDEFLIMIT             => XPRS_BARINDEFLIMIT            , 
:HEURSTRATEGY              => XPRS_HEURSTRATEGY             , 
:HEURFREQ                  => XPRS_HEURFREQ                 , 
:HEURDEPTH                 => XPRS_HEURDEPTH                , 
:HEURMAXSOL                => XPRS_HEURMAXSOL               , 
:HEURNODES                 => XPRS_HEURNODES                , 
:LNPBEST                   => XPRS_LNPBEST                  , 
:LNPITERLIMIT              => XPRS_LNPITERLIMIT             , 
:BRANCHCHOICE              => XPRS_BRANCHCHOICE             , 
:BARREGULARIZE             => XPRS_BARREGULARIZE            , 
:SBSELECT                  => XPRS_SBSELECT                 , 
:LOCALCHOICE               => XPRS_LOCALCHOICE              , 
:LOCALBACKTRACK            => XPRS_LOCALBACKTRACK           , 
:DUALSTRATEGY              => XPRS_DUALSTRATEGY             , 
:L1CACHE                   => XPRS_L1CACHE                  , 
:HEURDIVESTRATEGY          => XPRS_HEURDIVESTRATEGY         , 
:HEURSELECT                => XPRS_HEURSELECT               , 
:BARSTART                  => XPRS_BARSTART                 , 
:BARNUMSTABILITY           => XPRS_BARNUMSTABILITY          , 
:EXTRASETS                 => XPRS_EXTRASETS                , 
:FEASIBILITYPUMP           => XPRS_FEASIBILITYPUMP          , 
:PRECOEFELIM               => XPRS_PRECOEFELIM              , 
:PREDOMCOL                 => XPRS_PREDOMCOL                , 
:HEURSEARCHFREQ            => XPRS_HEURSEARCHFREQ           , 
:HEURDIVESPEEDUP           => XPRS_HEURDIVESPEEDUP          , 
:SBESTIMATE                => XPRS_SBESTIMATE               , 
:BARCORES                  => XPRS_BARCORES                 , 
:MAXCHECKSONMAXTIME        => XPRS_MAXCHECKSONMAXTIME       , 
:MAXCHECKSONMAXCUTTIME     => XPRS_MAXCHECKSONMAXCUTTIME    , 
:HISTORYCOSTS              => XPRS_HISTORYCOSTS             , 
:ALGAFTERCROSSOVER         => XPRS_ALGAFTERCROSSOVER        , 
:LINELENGTH                => XPRS_LINELENGTH               , 
:MUTEXCALLBACKS            => XPRS_MUTEXCALLBACKS           , 
:BARCRASH                  => XPRS_BARCRASH                 , 
:HEURDIVESOFTROUNDING      => XPRS_HEURDIVESOFTROUNDING     , 
:HEURSEARCHROOTSELECT      => XPRS_HEURSEARCHROOTSELECT     , 
:HEURSEARCHTREESELECT      => XPRS_HEURSEARCHTREESELECT     , 
:MPS18COMPATIBLE           => XPRS_MPS18COMPATIBLE          , 
:ROOTPRESOLVE              => XPRS_ROOTPRESOLVE             , 
:CROSSOVERDRP              => XPRS_CROSSOVERDRP             , 
:FORCEOUTPUT               => XPRS_FORCEOUTPUT              , 
:DETERMINISTIC             => XPRS_DETERMINISTIC            , 
:PREPROBING                => XPRS_PREPROBING               , 
:EXTRAQCELEMENTS           => XPRS_EXTRAQCELEMENTS          , 
:EXTRAQCROWS               => XPRS_EXTRAQCROWS              , 
:TREEMEMORYLIMIT           => XPRS_TREEMEMORYLIMIT          , 
:TREECOMPRESSION           => XPRS_TREECOMPRESSION          , 
:TREEDIAGNOSTICS           => XPRS_TREEDIAGNOSTICS          , 
:MAXGLOBALFILESIZE         => XPRS_MAXGLOBALFILESIZE        , 
:TEMPBOUNDS                => XPRS_TEMPBOUNDS               , 
:IFCHECKCONVEXITY          => XPRS_IFCHECKCONVEXITY         , 
:PRIMALUNSHIFT             => XPRS_PRIMALUNSHIFT            , 
:REPAIRINDEFINITEQ         => XPRS_REPAIRINDEFINITEQ        , 
:MAXLOCALBACKTRACK         => XPRS_MAXLOCALBACKTRACK        , 
:BACKTRACKTIE              => XPRS_BACKTRACKTIE             , 
:BRANCHDISJ                => XPRS_BRANCHDISJ               , 
:MIPFRACREDUCE             => XPRS_MIPFRACREDUCE            , 
:CONCURRENTTHREADS         => XPRS_CONCURRENTTHREADS        , 
:MAXSCALEFACTOR            => XPRS_MAXSCALEFACTOR           , 
:HEURTHREADS               => XPRS_HEURTHREADS              , 
:THREADS                   => XPRS_THREADS                  , 
:HEURBEFORELP              => XPRS_HEURBEFORELP             , 
:PREDOMROW                 => XPRS_PREDOMROW                , 
:BRANCHSTRUCTURAL          => XPRS_BRANCHSTRUCTURAL         , 
:QUADRATICUNSHIFT          => XPRS_QUADRATICUNSHIFT         , 
:BARPRESOLVEOPS            => XPRS_BARPRESOLVEOPS           , 
:QSIMPLEXOPS               => XPRS_QSIMPLEXOPS              , 
:CONFLICTCUTS              => XPRS_CONFLICTCUTS             , 
:CORESPERCPU               => XPRS_CORESPERCPU              , 
:SLEEPONTHREADWAIT         => XPRS_SLEEPONTHREADWAIT        , 
:PREDUPROW                 => XPRS_PREDUPROW                , 
:CPUPLATFORM               => XPRS_CPUPLATFORM              , 
:BARALG                    => XPRS_BARALG                   , 
:TREEPRESOLVE              => XPRS_TREEPRESOLVE             , 
:TREEPRESOLVE_KEEPBASIS    => XPRS_TREEPRESOLVE_KEEPBASIS   , 
:TREEPRESOLVEOPS           => XPRS_TREEPRESOLVEOPS          , 
:LPLOGSTYLE                => XPRS_LPLOGSTYLE               , 
:RANDOMSEED                => XPRS_RANDOMSEED               , 
:TREEQCCUTS                => XPRS_TREEQCCUTS               , 
:PRELINDEP                 => XPRS_PRELINDEP                , 
:DUALTHREADS               => XPRS_DUALTHREADS              , 
:PREOBJCUTDETECT           => XPRS_PREOBJCUTDETECT          , 
:PREBNDREDQUAD             => XPRS_PREBNDREDQUAD            , 
:PREBNDREDCONE             => XPRS_PREBNDREDCONE            , 
:PRECOMPONENTS             => XPRS_PRECOMPONENTS            , 
# #control parameters that => XPRS_ #control parameters that, 
:EXTRAELEMS                => XPRS_EXTRAELEMS               , 
:EXTRAPRESOLVE             => XPRS_EXTRAPRESOLVE            , 
:EXTRASETELEMS             => XPRS_EXTRASETELEMS            
)