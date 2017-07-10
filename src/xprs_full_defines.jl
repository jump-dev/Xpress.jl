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
const XPRS_PLUSINFINITY  = convert(Float64,     1.0e+20 )
const XPRS_MINUSINFINITY = convert(Float64,    -1.0e+20 )
const XPRS_MAXINT        = convert(Cint,  2147483647 )
const XPVERSION          = convert(Cint,          27 )

#***************************************************************************\
# * control parameters for XPRSprob                                         *
#***************************************************************************/
# String control parameters */
const XPRS_MPSRHSNAME                 = convert(Cint ,             6001)
const XPRS_MPSOBJNAME                 = convert(Cint ,             6002)
const XPRS_MPSRANGENAME               = convert(Cint ,             6003)
const XPRS_MPSBOUNDNAME               = convert(Cint ,             6004)
const XPRS_OUTPUTMASK                 = convert(Cint ,             6005)
#/* Double control parameters */
const XPRS_MATRIXTOL                  =convert(Cint,               7001 )
const XPRS_PIVOTTOL                   =convert(Cint,               7002 )
const XPRS_FEASTOL                    =convert(Cint,               7003 )
const XPRS_OUTPUTTOL                  =convert(Cint,               7004 )
const XPRS_SOSREFTOL                  =convert(Cint,               7005 )
const XPRS_OPTIMALITYTOL              =convert(Cint,               7006 )
const XPRS_ETATOL                     =convert(Cint,               7007 )
const XPRS_RELPIVOTTOL                =convert(Cint,               7008 )
const XPRS_MIPTOL                     =convert(Cint,               7009 )
const XPRS_MIPADDCUTOFF               =convert(Cint,               7012 )
const XPRS_MIPABSCUTOFF               =convert(Cint,               7013 )
const XPRS_MIPRELCUTOFF               =convert(Cint,               7014 )
const XPRS_PSEUDOCOST                 =convert(Cint,               7015 )
const XPRS_PENALTY                    =convert(Cint,               7016 )
const XPRS_BIGM                       =convert(Cint,               7018 )
const XPRS_MIPABSSTOP                 =convert(Cint,               7019 )
const XPRS_MIPRELSTOP                 =convert(Cint,               7020 )
const XPRS_CROSSOVERACCURACYTOL       =convert(Cint,               7023 )
const XPRS_CHOLESKYTOL                =convert(Cint,               7032 )
const XPRS_BARGAPSTOP                 =convert(Cint,               7033 )
const XPRS_BARDUALSTOP                =convert(Cint,               7034 )
const XPRS_BARPRIMALSTOP              =convert(Cint,               7035 )
const XPRS_BARSTEPSTOP                =convert(Cint,               7036 )
const XPRS_ELIMTOL                    =convert(Cint,               7042 )
const XPRS_PERTURB                    =convert(Cint,               7044 )
const XPRS_MARKOWITZTOL               =convert(Cint,               7047 )
const XPRS_MIPABSGAPNOTIFY            =convert(Cint,               7064 )
const XPRS_MIPRELGAPNOTIFY            =convert(Cint,               7065 )
const XPRS_PPFACTOR                   =convert(Cint,               7069 )
const XPRS_REPAIRINDEFINITEQMAX       =convert(Cint,               7071 )
const XPRS_BARGAPTARGET               =convert(Cint,               7073 )
const XPRS_SBEFFORT                   =convert(Cint,               7086 )
const XPRS_HEURDIVERANDOMIZE          =convert(Cint,               7089 )
const XPRS_HEURSEARCHEFFORT           =convert(Cint,               7090 )
const XPRS_CUTFACTOR                  =convert(Cint,               7091 )
const XPRS_EIGENVALUETOL              =convert(Cint,               7097 )
const XPRS_INDLINBIGM                 =convert(Cint,               7099 )
const XPRS_TREEMEMORYSAVINGTARGET     =convert(Cint,               7100 )
const XPRS_GLOBALFILEBIAS             =convert(Cint,               7101 )
const XPRS_INDPRELINBIGM              =convert(Cint,               7102 )
const XPRS_RELAXTREEMEMORYLIMIT       =convert(Cint,               7105 )
const XPRS_MIPABSGAPNOTIFYOBJ         =convert(Cint,               7108 )
const XPRS_MIPABSGAPNOTIFYBOUND       =convert(Cint,               7109 )
const XPRS_PRESOLVEMAXGROW            =convert(Cint,               7110 )
const XPRS_HEURSEARCHTARGETSIZE       =convert(Cint,               7112 )
const XPRS_CROSSOVERRELPIVOTTOL       =convert(Cint,               7113 )
const XPRS_CROSSOVERRELPIVOTTOLSAFE   =convert(Cint,               7114 )
const XPRS_DETLOGFREQ                 =convert(Cint,               7116 )
const XPRS_FEASTOLTARGET              =convert(Cint,               7121 )
const XPRS_OPTIMALITYTOLTARGET        =convert(Cint,               7122 )
#/* Integer control parameters */
const XPRS_EXTRAROWS                  =convert(Cint,               8004 )
const XPRS_EXTRACOLS                  =convert(Cint,               8005 )
const XPRS_LPITERLIMIT                =convert(Cint,               8007 )
const XPRS_LPLOG                      =convert(Cint,               8009 )
const XPRS_SCALING                    =convert(Cint,               8010 )
const XPRS_PRESOLVE                   =convert(Cint,               8011 )
const XPRS_CRASH                      =convert(Cint,               8012 )
const XPRS_PRICINGALG                 =convert(Cint,               8013 )
const XPRS_INVERTFREQ                 =convert(Cint,               8014 )
const XPRS_INVERTMIN                  =convert(Cint,               8015 )
const XPRS_MAXNODE                    =convert(Cint,               8018 )
const XPRS_MAXTIME                    =convert(Cint,               8020 )
const XPRS_MAXMIPSOL                  =convert(Cint,               8021 )
const XPRS_DEFAULTALG                 =convert(Cint,               8023 )
const XPRS_VARSELECTION               =convert(Cint,               8025 )
const XPRS_NODESELECTION              =convert(Cint,               8026 )
const XPRS_BACKTRACK                  =convert(Cint,               8027 )
const XPRS_MIPLOG                     =convert(Cint,               8028 )
const XPRS_KEEPNROWS                  =convert(Cint,               8030 )
const XPRS_MPSECHO                    =convert(Cint,               8032 )
const XPRS_MAXPAGELINES               =convert(Cint,               8034 )
const XPRS_OUTPUTLOG                  =convert(Cint,               8035 )
const XPRS_BARSOLUTION                =convert(Cint,               8038 )
const XPRS_CACHESIZE                  =convert(Cint,               8043 )
const XPRS_CROSSOVER                  =convert(Cint,               8044 )
const XPRS_BARITERLIMIT               =convert(Cint,               8045 )
const XPRS_CHOLESKYALG                =convert(Cint,               8046 )
const XPRS_BAROUTPUT                  =convert(Cint,               8047 )
const XPRS_CSTYLE                     =convert(Cint,               8050 )
const XPRS_EXTRAMIPENTS               =convert(Cint,               8051 )
const XPRS_REFACTOR                   =convert(Cint,               8052 )
const XPRS_BARTHREADS                 =convert(Cint,               8053 )
const XPRS_KEEPBASIS                  =convert(Cint,               8054 )
const XPRS_VERSION                    =convert(Cint,               8061 )
const XPRS_BIGMMETHOD                 =convert(Cint,               8068 )
const XPRS_MPSNAMELENGTH              =convert(Cint,               8071 )
const XPRS_PRESOLVEOPS                =convert(Cint,               8077 )
const XPRS_MIPPRESOLVE                =convert(Cint,               8078 )
const XPRS_MIPTHREADS                 =convert(Cint,               8079 )
const XPRS_BARORDER                   =convert(Cint,               8080 )
const XPRS_BREADTHFIRST               =convert(Cint,               8082 )
const XPRS_AUTOPERTURB                =convert(Cint,               8084 )
const XPRS_DENSECOLLIMIT              =convert(Cint,               8086 )
const XPRS_CALLBACKFROMMASTERTHREAD   =convert(Cint,               8090 )
const XPRS_MAXMCOEFFBUFFERELEMS       =convert(Cint,               8091 )
const XPRS_REFINEOPS                  =convert(Cint,               8093 )
const XPRS_LPREFINEITERLIMIT          =convert(Cint,               8094 )
const XPRS_DUALIZEOPS                 =convert(Cint,               8097 )
const XPRS_MAXMEMORY                  =convert(Cint,               8112 )
const XPRS_CUTFREQ                    =convert(Cint,               8116 )
const XPRS_SYMSELECT                  =convert(Cint,               8117 )
const XPRS_SYMMETRY                   =convert(Cint,               8118 )
const XPRS_LPTHREADS                  =convert(Cint,               8124 )
const XPRS_MIQCPALG                   =convert(Cint,               8125 )
const XPRS_QCCUTS                     =convert(Cint,               8126 )
const XPRS_QCROOTALG                  =convert(Cint,               8127 )
const XPRS_ALGAFTERNETWORK            =convert(Cint,               8129 )
const XPRS_TRACE                      =convert(Cint,               8130 )
const XPRS_MAXIIS                     =convert(Cint,               8131 )
const XPRS_CPUTIME                    =convert(Cint,               8133 )
const XPRS_COVERCUTS                  =convert(Cint,               8134 )
const XPRS_GOMCUTS                    =convert(Cint,               8135 )
const XPRS_MPSFORMAT                  =convert(Cint,               8137 )
const XPRS_CUTSTRATEGY                =convert(Cint,               8138 )
const XPRS_CUTDEPTH                   =convert(Cint,               8139 )
const XPRS_TREECOVERCUTS              =convert(Cint,               8140 )
const XPRS_TREEGOMCUTS                =convert(Cint,               8141 )
const XPRS_CUTSELECT                  =convert(Cint,               8142 )
const XPRS_TREECUTSELECT              =convert(Cint,               8143 )
const XPRS_DUALIZE                    =convert(Cint,               8144 )
const XPRS_DUALGRADIENT               =convert(Cint,               8145 )
const XPRS_SBITERLIMIT                =convert(Cint,               8146 )
const XPRS_SBBEST                     =convert(Cint,               8147 )
const XPRS_MAXCUTTIME                 =convert(Cint,               8149 )
const XPRS_ACTIVESET                  =convert(Cint,               8152 )
const XPRS_BARINDEFLIMIT              =convert(Cint,               8153 )
const XPRS_HEURSTRATEGY               =convert(Cint,               8154 )
const XPRS_HEURFREQ                   =convert(Cint,               8155 )
const XPRS_HEURDEPTH                  =convert(Cint,               8156 )
const XPRS_HEURMAXSOL                 =convert(Cint,               8157 )
const XPRS_HEURNODES                  =convert(Cint,               8158 )
const XPRS_LNPBEST                    =convert(Cint,               8160 )
const XPRS_LNPITERLIMIT               =convert(Cint,               8161 )
const XPRS_BRANCHCHOICE               =convert(Cint,               8162 )
const XPRS_BARREGULARIZE              =convert(Cint,               8163 )
const XPRS_SBSELECT                   =convert(Cint,               8164 )
const XPRS_LOCALCHOICE                =convert(Cint,               8170 )
const XPRS_LOCALBACKTRACK             =convert(Cint,               8171 )
const XPRS_DUALSTRATEGY               =convert(Cint,               8174 )
const XPRS_L1CACHE                    =convert(Cint,               8175 )
const XPRS_HEURDIVESTRATEGY           =convert(Cint,               8177 )
const XPRS_HEURSELECT                 =convert(Cint,               8178 )
const XPRS_BARSTART                   =convert(Cint,               8180 )
const XPRS_BARNUMSTABILITY            =convert(Cint,               8186 )
const XPRS_EXTRASETS                  =convert(Cint,               8190 )
const XPRS_FEASIBILITYPUMP            =convert(Cint,               8193 )
const XPRS_PRECOEFELIM                =convert(Cint,               8194 )
const XPRS_PREDOMCOL                  =convert(Cint,               8195 )
const XPRS_HEURSEARCHFREQ             =convert(Cint,               8196 )
const XPRS_HEURDIVESPEEDUP            =convert(Cint,               8197 )
const XPRS_SBESTIMATE                 =convert(Cint,               8198 )
const XPRS_BARCORES                   =convert(Cint,               8202 )
const XPRS_MAXCHECKSONMAXTIME         =convert(Cint,               8203 )
const XPRS_MAXCHECKSONMAXCUTTIME      =convert(Cint,               8204 )
const XPRS_HISTORYCOSTS               =convert(Cint,               8206 )
const XPRS_ALGAFTERCROSSOVER          =convert(Cint,               8208 )
const XPRS_LINELENGTH                 =convert(Cint,               8209 )
const XPRS_MUTEXCALLBACKS             =convert(Cint,               8210 )
const XPRS_BARCRASH                   =convert(Cint,               8211 )
const XPRS_HEURDIVESOFTROUNDING       =convert(Cint,               8215 )
const XPRS_HEURSEARCHROOTSELECT       =convert(Cint,               8216 )
const XPRS_HEURSEARCHTREESELECT       =convert(Cint,               8217 )
const XPRS_MPS18COMPATIBLE            =convert(Cint,               8223 )
const XPRS_ROOTPRESOLVE               =convert(Cint,               8224 )
const XPRS_CROSSOVERDRP               =convert(Cint,               8227 )
const XPRS_FORCEOUTPUT                =convert(Cint,               8229 )
const XPRS_DETERMINISTIC              =convert(Cint,               8232 )
const XPRS_PREPROBING                 =convert(Cint,               8238 )
const XPRS_EXTRAQCELEMENTS            =convert(Cint,               8240 )
const XPRS_EXTRAQCROWS                =convert(Cint,               8241 )
const XPRS_TREEMEMORYLIMIT            =convert(Cint,               8242 )
const XPRS_TREECOMPRESSION            =convert(Cint,               8243 )
const XPRS_TREEDIAGNOSTICS            =convert(Cint,               8244 )
const XPRS_MAXGLOBALFILESIZE          =convert(Cint,               8245 )
const XPRS_TEMPBOUNDS                 =convert(Cint,               8250 )
const XPRS_IFCHECKCONVEXITY           =convert(Cint,               8251 )
const XPRS_PRIMALUNSHIFT              =convert(Cint,               8252 )
const XPRS_REPAIRINDEFINITEQ          =convert(Cint,               8254 )
const XPRS_MAXLOCALBACKTRACK          =convert(Cint,               8257 )
const XPRS_BACKTRACKTIE               =convert(Cint,               8266 )
const XPRS_BRANCHDISJ                 =convert(Cint,               8267 )
const XPRS_MIPFRACREDUCE              =convert(Cint,               8270 )
const XPRS_CONCURRENTTHREADS          =convert(Cint,               8274 )
const XPRS_MAXSCALEFACTOR             =convert(Cint,               8275 )
const XPRS_HEURTHREADS                =convert(Cint,               8276 )
const XPRS_THREADS                    =convert(Cint,               8278 )
const XPRS_HEURBEFORELP               =convert(Cint,               8280 )
const XPRS_PREDOMROW                  =convert(Cint,               8281 )
const XPRS_BRANCHSTRUCTURAL           =convert(Cint,               8282 )
const XPRS_QUADRATICUNSHIFT           =convert(Cint,               8284 )
const XPRS_BARPRESOLVEOPS             =convert(Cint,               8286 )
const XPRS_QSIMPLEXOPS                =convert(Cint,               8288 )
const XPRS_CONFLICTCUTS               =convert(Cint,               8292 )
const XPRS_CORESPERCPU                =convert(Cint,               8296 )
const XPRS_SLEEPONTHREADWAIT          =convert(Cint,               8302 )
const XPRS_PREDUPROW                  =convert(Cint,               8307 )
const XPRS_CPUPLATFORM                =convert(Cint,               8312 )
const XPRS_BARALG                     =convert(Cint,               8315 )
const XPRS_TREEPRESOLVE               =convert(Cint,               8320 )
const XPRS_TREEPRESOLVE_KEEPBASIS     =convert(Cint,               8321 )
const XPRS_TREEPRESOLVEOPS            =convert(Cint,               8322 )
const XPRS_LPLOGSTYLE                 =convert(Cint,               8326 )
const XPRS_RANDOMSEED                 =convert(Cint,               8328 )
const XPRS_TREEQCCUTS                 =convert(Cint,               8331 )
const XPRS_PRELINDEP                  =convert(Cint,               8333 )
const XPRS_DUALTHREADS                =convert(Cint,               8334 )
const XPRS_PREOBJCUTDETECT            =convert(Cint,               8336 )
const XPRS_PREBNDREDQUAD              =convert(Cint,               8337 )
const XPRS_PREBNDREDCONE              =convert(Cint,               8338 )
const XPRS_PRECOMPONENTS              =convert(Cint,               8339 )
#/* Integer control parameters that support 64-bit values  */
const XPRS_EXTRAELEMS                 =convert(Cint,               8006 )
const XPRS_EXTRAPRESOLVE              =convert(Cint,               8037 )
const XPRS_EXTRASETELEMS              =convert(Cint,               8191 )

#***************************************************************************\
#* attributes for XPRSprob                                                 *
#***************************************************************************/
#/* String attributes */
const XPRS_MATRIXNAME                  =convert(Cint,              3001 )
const XPRS_BOUNDNAME                   =convert(Cint,              3002 )
const XPRS_OBJNAME                     =convert(Cint,              3003 )
const XPRS_RHSNAME                     =convert(Cint,              3004 )
const XPRS_RANGENAME                   =convert(Cint,              3005 )
#/* Double attributes */
const XPRS_LPOBJVAL                    =convert(Cint,              2001)
const XPRS_SUMPRIMALINF                =convert(Cint,              2002)
const XPRS_MIPOBJVAL                   =convert(Cint,              2003)
const XPRS_BESTBOUND                   =convert(Cint,              2004)
const XPRS_OBJRHS                      =convert(Cint,              2005)
const XPRS_MIPBESTOBJVAL               =convert(Cint,              2006)
const XPRS_OBJSENSE                    =convert(Cint,              2008)
const XPRS_BRANCHVALUE                 =convert(Cint,              2009)
const XPRS_PENALTYVALUE                =convert(Cint,              2061)
const XPRS_CURRMIPCUTOFF               =convert(Cint,              2062)
const XPRS_BARCONDA                    =convert(Cint,              2063)
const XPRS_BARCONDD                    =convert(Cint,              2064)
const XPRS_BARPRIMALOBJ                =convert(Cint,              4001)
const XPRS_BARDUALOBJ                  =convert(Cint,              4002)
const XPRS_BARPRIMALINF                =convert(Cint,              4003)
const XPRS_BARDUALINF                  =convert(Cint,              4004)
const XPRS_BARCGAP                     =convert(Cint,              4005)
#/* Integer attributes */
const XPRS_ROWS                        =convert(Cint,              1001 )
const XPRS_SETS                        =convert(Cint,              1004 )
const XPRS_PRIMALINFEAS                =convert(Cint,              1007 )
const XPRS_DUALINFEAS                  =convert(Cint,              1008 )
const XPRS_SIMPLEXITER                 =convert(Cint,              1009 )
const XPRS_LPSTATUS                    =convert(Cint,              1010 )
const XPRS_MIPSTATUS                   =convert(Cint,              1011 )
const XPRS_CUTS                        =convert(Cint,              1012 )
const XPRS_NODES                       =convert(Cint,              1013 )
const XPRS_NODEDEPTH                   =convert(Cint,              1014 )
const XPRS_ACTIVENODES                 =convert(Cint,              1015 )
const XPRS_MIPSOLNODE                  =convert(Cint,              1016 )
const XPRS_MIPSOLS                     =convert(Cint,              1017 )
const XPRS_COLS                        =convert(Cint,              1018 )
const XPRS_SPAREROWS                   =convert(Cint,              1019 )
const XPRS_SPARECOLS                   =convert(Cint,              1020 )
const XPRS_SPAREMIPENTS                =convert(Cint,              1022 )
const XPRS_ERRORCODE                   =convert(Cint,              1023 )
const XPRS_MIPINFEAS                   =convert(Cint,              1024 )
const XPRS_PRESOLVESTATE               =convert(Cint,              1026 )
const XPRS_PARENTNODE                  =convert(Cint,              1027 )
const XPRS_NAMELENGTH                  =convert(Cint,              1028 )
const XPRS_QELEMS                      =convert(Cint,              1030 )
const XPRS_NUMIIS                      =convert(Cint,              1031 )
const XPRS_MIPENTS                     =convert(Cint,              1032 )
const XPRS_BRANCHVAR                   =convert(Cint,              1036 )
const XPRS_MIPTHREADID                 =convert(Cint,              1037 )
const XPRS_ALGORITHM                   =convert(Cint,              1049 )
const XPRS_ORIGINALROWS                =convert(Cint,              1124 )
const XPRS_ORIGINALQELEMS              =convert(Cint,              1157 )
const XPRS_STOPSTATUS                  =convert(Cint,              1179 )
const XPRS_ORIGINALMIPENTS             =convert(Cint,              1191 )
const XPRS_ORIGINALSETS                =convert(Cint,              1194 )
const XPRS_SPARESETS                   =convert(Cint,              1203 )
const XPRS_CHECKSONMAXTIME             =convert(Cint,              1208 )
const XPRS_CHECKSONMAXCUTTIME          =convert(Cint,              1209 )
const XPRS_ORIGINALCOLS                =convert(Cint,              1214 )
const XPRS_QCELEMS                     =convert(Cint,              1232 )
const XPRS_QCONSTRAINTS                =convert(Cint,              1234 )
const XPRS_ORIGINALQCELEMS             =convert(Cint,              1237 )
const XPRS_ORIGINALQCONSTRAINTS        =convert(Cint,              1239 )
const XPRS_PEAKTOTALTREEMEMORYUSAGE    =convert(Cint,              1240 )
const XPRS_CURRENTNODE                 =convert(Cint,              1248 )
const XPRS_TREEMEMORYUSAGE             =convert(Cint,              1251 )
const XPRS_GLOBALFILESIZE              =convert(Cint,              1252 )
const XPRS_GLOBALFILEUSAGE             =convert(Cint,              1253 )
const XPRS_INDICATORS                  =convert(Cint,              1254 )
const XPRS_ORIGINALINDICATORS          =convert(Cint,              1255 )
const XPRS_CORESDETECTED               =convert(Cint,              1260 )
const XPRS_BARSING                     =convert(Cint,              1281 )
const XPRS_BARSINGR                    =convert(Cint,              1282 )
const XPRS_PRESOLVEINDEX               =convert(Cint,              1284 )
const XPRS_CONES                       =convert(Cint,              1307 )
const XPRS_CONEELEMS                   =convert(Cint,              1308 )
const XPRS_BARITER                     =convert(Cint,              5001 )
const XPRS_BARAASIZE                   =convert(Cint,              5002 )
const XPRS_BARLSIZE                    =convert(Cint,              5003 )
const XPRS_BARDENSECOL                 =convert(Cint,              5004 )
const XPRS_BARCROSSOVER                =convert(Cint,              5005 )
#/* XPRS_IIS has been renamed XPRS_NUMIIS to avoid confusion with the XPRSiis
#   function.  XPRS_IIS is defined here for your convenience. */
const XPRS_IIS = XPRS_NUMIIS
#/* Integer attributes that support 64-bit values */
const XPRS_SETMEMBERS                  =convert(Cint,              1005 )
const XPRS_ELEMS                       =convert(Cint,              1006 )
const XPRS_SPAREELEMS                  =convert(Cint,              1021 )
const XPRS_ORIGINALSETMEMBERS          =convert(Cint,              1195 )
const XPRS_SPARESETELEMS               =convert(Cint,              1204 )

#/***************************************************************************\
# * control parameters for XPRSmipsolpool                                   *
#\***************************************************************************/
#/* Double control parameters */
const XPRS_MSP_DEFAULTUSERSOLFEASTOL      =convert(Cint,           6209 )
const XPRS_MSP_DEFAULTUSERSOLMIPTOL       =convert(Cint,           6210 )
const XPRS_MSP_SOL_FEASTOL                =convert(Cint,           6402 )
const XPRS_MSP_SOL_MIPTOL                 =convert(Cint,           6403 )
#/* Integer control parameters */
const XPRS_MSP_DUPLICATESOLUTIONSPOLICY   =convert(Cint,           6203 )
const XPRS_MSP_INCLUDEPROBNAMEINLOGGING   =convert(Cint,           6211 )
const XPRS_MSP_WRITESLXSOLLOGGING         =convert(Cint,           6212 )
const XPRS_MSP_ENABLESLACKSTORAGE         =convert(Cint,           6213 )
const XPRS_MSP_OUTPUTLOG                  =convert(Cint,           6214 )
const XPRS_MSP_SOL_BITFIELDSUSR           =convert(Cint,           6406 )

#/***************************************************************************\
# * attributes for XPRSmipsolpool                                           *
#\***************************************************************************/
#/* Double attributes */
const XPRS_MSP_SOLPRB_OBJ                 =convert(Cint,           6500 )
const XPRS_MSP_SOLPRB_INFSUM_PRIMAL       =convert(Cint,           6502 )
const XPRS_MSP_SOLPRB_INFSUM_MIP          =convert(Cint,           6504 )
const XPRS_MSP_SOLPRB_INFSUM_SLACK        =convert(Cint,           6506 )
const XPRS_MSP_SOLPRB_INFMAX_SLACK        =convert(Cint,           6508 )
const XPRS_MSP_SOLPRB_INFSUM_COLUMN       =convert(Cint,           6510 )
const XPRS_MSP_SOLPRB_INFMAX_COLUMN       =convert(Cint,           6512 )
const XPRS_MSP_SOLPRB_INFSUM_DELAYEDROW   =convert(Cint,           6514 )
const XPRS_MSP_SOLPRB_INFMAX_DELAYEDROW   =convert(Cint,           6516 )
const XPRS_MSP_SOLPRB_INFSUM_INT          =convert(Cint,           6518 )
const XPRS_MSP_SOLPRB_INFMAX_INT          =convert(Cint,           6520 )
const XPRS_MSP_SOLPRB_INFSUM_BIN          =convert(Cint,           6522 )
const XPRS_MSP_SOLPRB_INFMAX_BIN          =convert(Cint,           6524 )
const XPRS_MSP_SOLPRB_INFSUM_SC           =convert(Cint,           6526 )
const XPRS_MSP_SOLPRB_INFMAX_SC           =convert(Cint,           6528 )
const XPRS_MSP_SOLPRB_INFSUM_SI           =convert(Cint,           6530 )
const XPRS_MSP_SOLPRB_INFMAX_SI           =convert(Cint,           6532 )
const XPRS_MSP_SOLPRB_INFSUM_PI           =convert(Cint,           6534 )
const XPRS_MSP_SOLPRB_INFMAX_PI           =convert(Cint,           6536 )
const XPRS_MSP_SOLPRB_INFSUM_SET1         =convert(Cint,           6538 )
const XPRS_MSP_SOLPRB_INFMAX_SET1         =convert(Cint,           6540 )
const XPRS_MSP_SOLPRB_INFSUM_SET2         =convert(Cint,           6542 )
const XPRS_MSP_SOLPRB_INFMAX_SET2         =convert(Cint,           6544 )
#/* Integer attributes */
const XPRS_MSP_SOLUTIONS                       =convert(Cint,      6208 )
const XPRS_MSP_PRB_VALIDSOLS                   =convert(Cint,      6300 )
const XPRS_MSP_PRB_FEASIBLESOLS                =convert(Cint,      6301 )
const XPRS_MSP_SOL_COLS                        =convert(Cint,      6400 )
const XPRS_MSP_SOL_NONZEROS                    =convert(Cint,      6401 )
const XPRS_MSP_SOL_ISUSERSOLUTION              =convert(Cint,      6404 )
const XPRS_MSP_SOL_ISREPROCESSEDUSERSOLUTION   =convert(Cint,      6405 )
const XPRS_MSP_SOL_BITFIELDSSYS                =convert(Cint,      6407 )
const XPRS_MSP_SOLPRB_INFEASCOUNT              =convert(Cint,      6501 )
const XPRS_MSP_SOLPRB_INFCNT_PRIMAL            =convert(Cint,      6503 )
const XPRS_MSP_SOLPRB_INFCNT_MIP               =convert(Cint,      6505 )
const XPRS_MSP_SOLPRB_INFCNT_SLACK             =convert(Cint,      6507 )
const XPRS_MSP_SOLPRB_INFMXI_SLACK             =convert(Cint,      6509 )
const XPRS_MSP_SOLPRB_INFCNT_COLUMN            =convert(Cint,      6511 )
const XPRS_MSP_SOLPRB_INFMXI_COLUMN            =convert(Cint,      6513 )
const XPRS_MSP_SOLPRB_INFCNT_DELAYEDROW        =convert(Cint,      6515 )
const XPRS_MSP_SOLPRB_INFMXI_DELAYEDROW        =convert(Cint,      6517 )
const XPRS_MSP_SOLPRB_INFCNT_INT               =convert(Cint,      6519 )
const XPRS_MSP_SOLPRB_INFMXI_INT               =convert(Cint,      6521 )
const XPRS_MSP_SOLPRB_INFCNT_BIN               =convert(Cint,      6523 )
const XPRS_MSP_SOLPRB_INFMXI_BIN               =convert(Cint,      6525 )
const XPRS_MSP_SOLPRB_INFCNT_SC                =convert(Cint,      6527 )
const XPRS_MSP_SOLPRB_INFMXI_SC                =convert(Cint,      6529 )
const XPRS_MSP_SOLPRB_INFCNT_SI                =convert(Cint,      6531 )
const XPRS_MSP_SOLPRB_INFMXI_SI                =convert(Cint,      6533 )
const XPRS_MSP_SOLPRB_INFCNT_PI                =convert(Cint,      6535 )
const XPRS_MSP_SOLPRB_INFMXI_PI                =convert(Cint,      6537 )
const XPRS_MSP_SOLPRB_INFCNT_SET1              =convert(Cint,      6539 )
const XPRS_MSP_SOLPRB_INFMXI_SET1              =convert(Cint,      6541 )
const XPRS_MSP_SOLPRB_INFCNT_SET2              =convert(Cint,      6543 )
const XPRS_MSP_SOLPRB_INFMXI_SET2              =convert(Cint,      6545 )

#/***************************************************************************\
# * control parameters for XPRSmipsolenum                                   *
#\***************************************************************************/
#/* Double control parameters */
const XPRS_MSE_OUTPUTTOL                       =convert(Cint,      6609 )
#/* Integer control parameters */
const XPRS_MSE_CALLBACKCULLSOLS_MIPOBJECT      =convert(Cint,      6601 )
const XPRS_MSE_CALLBACKCULLSOLS_DIVERSITY      =convert(Cint,      6602 )
const XPRS_MSE_CALLBACKCULLSOLS_MODOBJECT      =convert(Cint,      6603 )
const XPRS_MSE_OPTIMIZEDIVERSITY               =convert(Cint,      6607 )
const XPRS_MSE_OUTPUTLOG                       =convert(Cint,      6610 )

#/***************************************************************************\
# * attributes for XPRSmipsolenum                                           *
#\***************************************************************************/
#/* Double attributes */
const XPRS_MSE_DIVERSITYSUM                    =convert(Cint,      6608 )
#/* Integer attributes */
const XPRS_MSE_SOLUTIONS                       =convert(Cint,      6600 )
const XPRS_MSE_METRIC_MIPOBJECT                =convert(Cint,      6604 )
const XPRS_MSE_METRIC_DIVERSITY                =convert(Cint,      6605 )
const XPRS_MSE_METRIC_MODOBJECT                =convert(Cint,      6606 )

#/***************************************************************************\
# * control parameters for XPRSprobperturber                                *
#\***************************************************************************/
#/* Double control parameters */
const XPRS_PTB_PERMUTE_INTENSITY_ROW                    =convert(Cint, 6702 )
const XPRS_PTB_PERMUTE_INTENSITY_COL                    =convert(Cint, 6703 )
const XPRS_PTB_SHIFTSCALE_COLS_INTENSITY                =convert(Cint, 6722 )
const XPRS_PTB_SHIFTSCALE_COLS_MAXRANGEFORCOMPLEMENTING =convert(Cint, 6729 )
const XPRS_PTB_SHIFTSCALE_ROWS_INTENSITY                =convert(Cint, 6762 )
#/* Integer control parameters */
const XPRS_PTB_PERMUTE_ACTIVE                           =convert(Cint, 6700 )
const XPRS_PTB_PERMUTE_SEEDLAST                         =convert(Cint, 6701 )
const XPRS_PTB_PERTURB_COST2_ACTIVE                     =convert(Cint, 6710 )
const XPRS_PTB_PERTURB_COST2_SEEDLAST                   =convert(Cint, 6711 )
const XPRS_PTB_SHIFTSCALE_COLS_ACTIVE                   =convert(Cint, 6720 )
const XPRS_PTB_SHIFTSCALE_COLS_SEEDLAST                 =convert(Cint, 6721 )
const XPRS_PTB_SHIFTSCALE_COLS_SHIFT_ACTIVE_I           =convert(Cint, 6725 )
const XPRS_PTB_SHIFTSCALE_COLS_NEGATE_ACTIVE_I          =convert(Cint, 6726 )
const XPRS_PTB_SHIFTSCALE_COLS_COMPLEMENT_ACTIVE_I      =convert(Cint, 6727 )
const XPRS_PTB_SHIFTSCALE_COLS_COMPLEMENT_ACTIVE_B      =convert(Cint, 6728 )
const XPRS_PTB_SHIFTSCALE_ROWS_ACTIVE                   =convert(Cint, 6760 )
const XPRS_PTB_SHIFTSCALE_ROWS_SEEDLAST                 =convert(Cint, 6761 )

#/***************************************************************************\
# * attributes for XPRSprobperturber                                        *
#\***************************************************************************/
#/* Double attributes */
const XPRS_PTB_PERTURB_COST2_TOTALABSCOSTCHANGE        =convert(Cint,  6713 )
const XPRS_PTB_SHIFTSCALE_COLS_FIXEDOBJDELTA           =convert(Cint,  6724 )
#/* Integer attributes */
const XPRS_PTB_PERMUTE_PERMCOUNT_ROW                   =convert(Cint,  6704 )
const XPRS_PTB_PERMUTE_PERMCOUNT_COL                   =convert(Cint,  6705 )
const XPRS_PTB_PERTURB_COST2_CHANGEDCOLCOUNT           =convert(Cint,  6712 )
const XPRS_PTB_SHIFTSCALE_COLS_CHANGEDCOLCOUNT         =convert(Cint,  6723 )

#/***************************************************************************\
# * values related to LPSTATUS                                              *
#\***************************************************************************/
const XPRS_LP_UNSTARTED         =convert(Cint, 0 )
const XPRS_LP_OPTIMAL           =convert(Cint, 1 )
const XPRS_LP_INFEAS            =convert(Cint, 2 )
const XPRS_LP_CUTOFF            =convert(Cint, 3 )
const XPRS_LP_UNFINISHED        =convert(Cint, 4 )
const XPRS_LP_UNBOUNDED         =convert(Cint, 5 )
const XPRS_LP_CUTOFF_IN_DUAL    =convert(Cint, 6 )
const XPRS_LP_UNSOLVED          =convert(Cint, 7 )
const XPRS_LP_NONCONVEX         =convert(Cint, 8 )

#/***************************************************************************\
# * values related to MIPSTATUS                                             *
#\***************************************************************************/
const XPRS_MIP_NOT_LOADED       =convert(Cint, 0 )
const XPRS_MIP_LP_NOT_OPTIMAL   =convert(Cint, 1 )
const XPRS_MIP_LP_OPTIMAL       =convert(Cint, 2 )
const XPRS_MIP_NO_SOL_FOUND     =convert(Cint, 3 )
const XPRS_MIP_SOLUTION         =convert(Cint, 4 )
const XPRS_MIP_INFEAS           =convert(Cint, 5 )
const XPRS_MIP_OPTIMAL          =convert(Cint, 6 )
const XPRS_MIP_UNBOUNDED        =convert(Cint, 7 )

#/***************************************************************************\
# * values related to BARORDER                                              *
#\***************************************************************************/
const XPRS_BAR_DEFAULT            =convert(Cint, 0 )
const XPRS_BAR_MIN_DEGREE         =convert(Cint, 1 )
const XPRS_BAR_MIN_LOCAL_FILL     =convert(Cint, 2 )
const XPRS_BAR_NESTED_DISSECTION  =convert(Cint, 3 )

#/***************************************************************************\
# * values related to DEFAULTALG                                            *
#\***************************************************************************/
const XPRS_ALG_DEFAULT            =convert(Cint, 1 )
const XPRS_ALG_DUAL               =convert(Cint, 2 )
const XPRS_ALG_PRIMAL             =convert(Cint, 3 )
const XPRS_ALG_BARRIER            =convert(Cint, 4 )
const XPRS_ALG_NETWORK            =convert(Cint, 5 )

#/***************************************************************************\
# * values related to XPRSinterrupt                                         *
#\***************************************************************************/
const XPRS_STOP_NONE                    =convert(Cint, 0)
const XPRS_STOP_TIMELIMIT               =convert(Cint, 1)
const XPRS_STOP_CTRLC                   =convert(Cint, 2)
const XPRS_STOP_NODELIMIT               =convert(Cint, 3)
const XPRS_STOP_ITERLIMIT               =convert(Cint, 4)
const XPRS_STOP_MIPGAP                  =convert(Cint, 5)
const XPRS_STOP_SOLLIMIT                =convert(Cint, 6)
const XPRS_STOP_USER                    =convert(Cint, 9)

#/***************************************************************************\
# * values related to AlwaysNeverOrAutomatic                                  *
#\***************************************************************************/
const XPRS_ANA_AUTOMATIC               =convert(Cint, -1)
const XPRS_ANA_NEVER                   =convert(Cint, 0)
const XPRS_ANA_ALWAYS                  =convert(Cint, 1)

#/***************************************************************************\
# * values related to OnOrOff                                               *
#\***************************************************************************/
const XPRS_BOOL_OFF                     =convert(Cint, 0)
const XPRS_BOOL_ON                      =convert(Cint, 1)

#/***************************************************************************\
# * values related to BACKTRACK                                             *
#\***************************************************************************/
const XPRS_BACKTRACKALG_BEST_ESTIMATE            =convert(Cint,2)
const XPRS_BACKTRACKALG_BEST_BOUND               =convert(Cint,3)
const XPRS_BACKTRACKALG_DEEPEST_NODE             =convert(Cint,4)
const XPRS_BACKTRACKALG_HIGHEST_NODE             =convert(Cint,5)
const XPRS_BACKTRACKALG_EARLIEST_NODE            =convert(Cint,6)
const XPRS_BACKTRACKALG_LATEST_NODE              =convert(Cint,7)
const XPRS_BACKTRACKALG_RANDOM                   =convert(Cint,8)
const XPRS_BACKTRACKALG_MIN_INFEAS               =convert(Cint,9)
const XPRS_BACKTRACKALG_BEST_ESTIMATE_MIN_INFEAS =convert(Cint,10)
const XPRS_BACKTRACKALG_DEEPEST_BEST_ESTIMATE    =convert(Cint,11)

#/***************************************************************************\
# * values related to BRANCHCHOICE                                          *
#\***************************************************************************/
const XPRS_BRANCH_MIN_EST_FIRST            =convert(Cint,0)
const XPRS_BRANCH_MAX_EST_FIRST            =convert(Cint,1)

#/***************************************************************************\
# * values related to CHOLESKYALG                                           *
#\***************************************************************************/
const XPRS_ALG_PULL_CHOLESKY           =convert(Cint,0)
const XPRS_ALG_PUSH_CHOLESKY           =convert(Cint,1)

#/***************************************************************************\
# * values related to CROSSOVERDRP                                          *
#\***************************************************************************/
const XPRS_XDRPBEFORE_CROSSOVER        =convert(Cint,1)
const XPRS_XDRPINSIDE_CROSSOVER        =convert(Cint,2)
const XPRS_XDRPAGGRESSIVE_BEFORE_CROSSOVER =convert(Cint,4)

#/***************************************************************************\
# * values related to DUALGRADIENT                                          *
#\***************************************************************************/
const XPRS_DUALGRADIENT_AUTOMATIC               =convert(Cint, -1)
const XPRS_DUALGRADIENT_DEVEX                   =convert(Cint, 0)
const XPRS_DUALGRADIENT_STEEPESTEDGE            =convert(Cint, 1)

#/***************************************************************************\
# * values related to DUALSTRATEGY                                          *
#\***************************************************************************/
const XPRS_DUALSTRATEGY_REMOVE_INFEAS_WITH_PRIMAL=convert(Cint, 0)
const XPRS_DUALSTRATEGY_REMOVE_INFEAS_WITH_DUAL  =convert(Cint,1)

#/***************************************************************************\
# * values related to FEASIBILITYPUMP                                       *
#\***************************************************************************/
const XPRS_FEASIBILITYPUMP_NEVER                   =convert(Cint, 0)
const XPRS_FEASIBILITYPUMP_ALWAYS                  =convert(Cint, 1)
const XPRS_FEASIBILITYPUMP_LASTRESORT              =convert(Cint, 2)

#/***************************************************************************\
# * values related to HEURSEARCHSELECT                                      *
#\***************************************************************************/
const XPRS_HEURSEARCH_LOCAL_SEARCH_LARGE_NEIGHBOURHOOD =convert(Cint,0)
const XPRS_HEURSEARCH_LOCAL_SEARCH_NODE_NEIGHBOURHOOD =convert(Cint,1)
const XPRS_HEURSEARCH_LOCAL_SEARCH_SOLUTION_NEIGHBOURHOOD =convert(Cint,2)

#/***************************************************************************\
# * values related to HEURSTRATEGY                                          *
#\***************************************************************************/
const XPRS_HEURSTRATEGY_AUTOMATIC             =convert(Cint,  -1)
const XPRS_HEURSTRATEGY_NONE                  =convert(Cint,  0)
const XPRS_HEURSTRATEGY_BASIC                 =convert(Cint,  1)
const XPRS_HEURSTRATEGY_ENHANCED              =convert(Cint,  2)
const XPRS_HEURSTRATEGY_EXTENSIVE             =convert(Cint,  3)

#/***************************************************************************\
# * values related to NODESELECTION                                         *
#\***************************************************************************/
const XPRS_NODESELECTION_LOCAL_FIRST             =convert(Cint,1)
const XPRS_NODESELECTION_BEST_FIRST              =convert(Cint,2)
const XPRS_NODESELECTION_LOCAL_DEPTH_FIRST       =convert(Cint,3)
const XPRS_NODESELECTION_BEST_FIRST_THEN_LOCAL_FIRST =convert(Cint,4)
const XPRS_NODESELECTION_DEPTH_FIRST             =convert(Cint, 5)

#/***************************************************************************\
# * values related to OUTPUTLOG                                             *
#\***************************************************************************/
const XPRS_OUTPUTLOG_NO_OUTPUT                =convert(Cint,0)
const XPRS_OUTPUTLOG_FULL_OUTPUT              =convert(Cint,1)
const XPRS_OUTPUTLOG_ERRORS_AND_WARNINGS      =convert(Cint,2)
const XPRS_OUTPUTLOG_ERRORS                   =convert(Cint,3)

#/***************************************************************************\
# * values related to PREPROBING                                            *
#\***************************************************************************/
const XPRS_PREPROBING_AUTOMATIC               =convert(Cint, -1)
const XPRS_PREPROBING_DISABLED                =convert(Cint, 0)
const XPRS_PREPROBING_LIGHT                   =convert(Cint, 1)
const XPRS_PREPROBING_FULL                    =convert(Cint, 2)
const XPRS_PREPROBING_FULL_AND_REPEAT         =convert(Cint, 3)

#/***************************************************************************\
# * values related to PRESOLVEOPS                                           *
#\***************************************************************************/
const XPRS_PRESOLVEOPS_SINGLETONCOLUMNREMOVAL  =convert(Cint, 1)
const XPRS_PRESOLVEOPS_SINGLETONROWREMOVAL     =convert(Cint, 2)
const XPRS_PRESOLVEOPS_FORCINGROWREMOVAL       =convert(Cint, 4)
const XPRS_PRESOLVEOPS_DUALREDUCTIONS          =convert(Cint, 8)
const XPRS_PRESOLVEOPS_REDUNDANTROWREMOVAL     =convert(Cint, 16)
const XPRS_PRESOLVEOPS_DUPLICATECOLUMNREMOVAL  =convert(Cint, 32)
const XPRS_PRESOLVEOPS_DUPLICATEROWREMOVAL     =convert(Cint, 64)
const XPRS_PRESOLVEOPS_STRONGDUALREDUCTIONS    =convert(Cint, 128)
const XPRS_PRESOLVEOPS_VARIABLEELIMINATIONS    =convert(Cint, 256)
const XPRS_PRESOLVEOPS_NOIPREDUCTIONS          =convert(Cint, 512)
const XPRS_PRESOLVEOPS_NOADVANCEDIPREDUCTIONS  =convert(Cint, 2048)
const XPRS_PRESOLVEOPS_LINEARLYDEPENDANTROWREMOVAL =convert(Cint,16384)
const XPRS_PRESOLVEOPS_NOINTEGERVARIABLEANDSOSDETECTION =convert(Cint,32768)

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
const XPRS_MIPPRESOLVE_REDUCED_COST_FIXING      =convert(Cint,1)
const XPRS_MIPPRESOLVE_LOGIC_PREPROCESSING      =convert(Cint,2)
const XPRS_MIPPRESOLVE_ALLOW_CHANGE_BOUNDS      =convert(Cint,8)

#/***************************************************************************\
# * values related to PRESOLVE                                              *
#\***************************************************************************/
const XPRS_PRESOLVE_NOPRIMALINFEASIBILITY   =convert(Cint, -1)
const XPRS_PRESOLVE_NONE                    =convert(Cint, 0)
const XPRS_PRESOLVE_DEFAULT                 =convert(Cint, 1)
const XPRS_PRESOLVE_KEEPREDUNDANTBOUNDS     =convert(Cint, 2)

#/***************************************************************************\
# * values related to PRICINGALG                                            *
#\***************************************************************************/
const XPRS_PRICING_PARTIAL                 =convert(Cint, -1)
const XPRS_PRICING_DEFAULT                 =convert(Cint, 0)
const XPRS_PRICING_DEVEX                   =convert(Cint, 1)

#/***************************************************************************\
# * values related to CUTSTRATEGY                                           *
#\***************************************************************************/
const XPRS_CUTSTRATEGY_DEFAULT                 =convert(Cint, -1)
const XPRS_CUTSTRATEGY_NONE                    =convert(Cint, 0)
const XPRS_CUTSTRATEGY_CONSERVATIVE            =convert(Cint, 1)
const XPRS_CUTSTRATEGY_MODERATE                =convert(Cint, 2)
const XPRS_CUTSTRATEGY_AGGRESSIVE              =convert(Cint, 3)

#/***************************************************************************\
# * values related to VARSELECTION                                          *
#\***************************************************************************/
const XPRS_VARSELECTION_AUTOMATIC               =convert(Cint, -1)
const XPRS_VARSELECTION_MIN_UPDOWN_PSEUDO_COSTS =convert(Cint, 1)
const XPRS_VARSELECTION_SUM_UPDOWN_PSEUDO_COSTS =convert(Cint, 2)
const XPRS_VARSELECTION_MAX_UPDOWN_PSEUDO_COSTS_PLUS_TWICE_MIN =convert(Cint,3)
const XPRS_VARSELECTION_MAX_UPDOWN_PSEUDO_COSTS  =convert(Cint,4)
const XPRS_VARSELECTION_DOWN_PSEUDO_COST         =convert(Cint,5)
const XPRS_VARSELECTION_UP_PSEUDO_COST           =convert(Cint,6)

#/***************************************************************************\
# * values related to SCALING                                               *
#\***************************************************************************/
const XPRS_SCALING_ROW_SCALING             =convert(Cint, 1)
const XPRS_SCALING_COLUMN_SCALING          =convert(Cint, 2)
const XPRS_SCALING_ROW_SCALING_AGAIN       =convert(Cint, 4)
const XPRS_SCALING_MAXIMUM                 =convert(Cint, 8)
const XPRS_SCALING_CURTIS_REID             =convert(Cint, 16)
const XPRS_SCALING_BY_MAX_ELEM_NOT_GEO_MEAN=convert(Cint, 32)
const XPRS_SCALING_OBJECTIVE_SCALING       =convert(Cint, 64)
const XPRS_SCALING_EXCLUDE_QUADRATIC_FROM_SCALE_FACTOR =convert(Cint,128)
const XPRS_SCALING_IGNORE_QUADRATIC_ROW_PART=convert(Cint, 256)
const XPRS_SCALING_BEFORE_PRESOLVE          =convert(Cint,512)
const XPRS_SCALING_NO_SCALING_ROWS_UP       =convert(Cint,1024)
const XPRS_SCALING_NO_SCALING_COLUMNS_DOWN  =convert(Cint,2048)
const XPRS_SCALING_SIMPLEX_OBJECTIVE_SCALING=convert(Cint, 4096)
const XPRS_SCALING_RHS_SCALING              =convert(Cint,8192)
const XPRS_SCALING_NO_AGGRESSIVE_Q_SCALING  =convert(Cint,16384)
const XPRS_SCALING_SLACK_SCALING            =convert(Cint,32768)

#/***************************************************************************\
# * values related to CUTSELECT                                             *
#\***************************************************************************/
const XPRS_CUTSELECT_CLIQUE               =convert(Cint,    (32+1823)    )
const XPRS_CUTSELECT_MIR                  =convert(Cint,    (64+1823)    )
const XPRS_CUTSELECT_COVER                =convert(Cint,    (128+1823)   )
const XPRS_CUTSELECT_FLOWPATH             =convert(Cint,    (2048+1823)  )
const XPRS_CUTSELECT_IMPLICATION          =convert(Cint,    (4096+1823)  )
const XPRS_CUTSELECT_LIFT_AND_PROJECT     =convert(Cint,    (8192+1823)  )
const XPRS_CUTSELECT_DISABLE_CUT_ROWS     =convert(Cint,    (16384+1823) )
const XPRS_CUTSELECT_GUB_COVER            =convert(Cint,    (32768+1823) )
const XPRS_CUTSELECT_DEFAULT              =convert(Cint,    (-1)         )

#/***************************************************************************\
# * values related to REFINEOPS                                             *
#\***************************************************************************/
const XPRS_REFINEOPS_LPOPTIMAL              =convert(Cint,  1)
const XPRS_REFINEOPS_MIPSOLUTION            =convert(Cint,  2)
const XPRS_REFINEOPS_MIPOPTIMAL             =convert(Cint,  4)
const XPRS_REFINEOPS_MIPNODELP              =convert(Cint,  8)

#/***************************************************************************\
# * values related to DUALIZEOPS                                            *
#\***************************************************************************/
const XPRS_DUALIZEOPS_SWITCHALGORITHM          =convert(Cint,1)

#/***************************************************************************\
# * values related to TREEDIAGNOSTICS                                       *
#\***************************************************************************/
const XPRS_TREEDIAGNOSTICS_MEMORY_USAGE_SUMMARIES  =convert(Cint,1)
const XPRS_TREEDIAGNOSTICS_MEMORY_SAVED_REPORTS    =convert(Cint,2)

#/***************************************************************************\
# * values related to BARPRESOLVEOPS                                        *
#\***************************************************************************/
const XPRS_BARPRESOLVEOPS_STANDARD_PRESOLVE        =convert(Cint,0)
const XPRS_BARPRESOLVEOPS_EXTRA_BARRIER_PRESOLVE   =convert(Cint,1)

#/***************************************************************************\
# * values related to PRECOEFELIM                                           *
#\***************************************************************************/
const XPRS_PRECOEFELIM_DISABLED               =convert(Cint, 0 )
const XPRS_PRECOEFELIM_AGGRESSIVE             =convert(Cint, 1 )
const XPRS_PRECOEFELIM_CAUTIOUS               =convert(Cint, 2 )

#/***************************************************************************\
# * values related to PREDOMROW                                             *
#\***************************************************************************/
const XPRS_PREDOMROW_AUTOMATIC               =convert(Cint, -1)
const XPRS_PREDOMROW_DISABLED                =convert(Cint, 0)
const XPRS_PREDOMROW_CAUTIOUS                =convert(Cint, 1)
const XPRS_PREDOMROW_MEDIUM                  =convert(Cint, 2)
const XPRS_PREDOMROW_AGGRESSIVE              =convert(Cint, 3)

#/***************************************************************************\
# * values related to PREDOMCOL                                             *
#\***************************************************************************/
const XPRS_PREDOMCOL_AUTOMATIC               =convert(Cint, -1)
const XPRS_PREDOMCOL_DISABLED                =convert(Cint, 0)
const XPRS_PREDOMCOL_CAUTIOUS                =convert(Cint, 1)
const XPRS_PREDOMCOL_AGGRESSIVE              =convert(Cint, 2)

#/***************************************************************************\
# * values related to PRIMALUNSHIFT                                         *
#\***************************************************************************/
const XPRS_PRIMALUNSHIFT_ALLOW_DUAL_UNSHIFT      =convert(Cint, 0)
const XPRS_PRIMALUNSHIFT_NO_DUAL_UNSHIFT         =convert(Cint, 1)

#/***************************************************************************\
# * values related to REPAIRINDEFINITEQ                                     *
#\***************************************************************************/
const XPRS_REPAIRINDEFINITEQ_REPAIR_IF_POSSIBLE     =convert(Cint,  0)
const XPRS_REPAIRINDEFINITEQ_NO_REPAIR              =convert(Cint,  1)

#/***************************************************************************\
# * values related to Minimize/Maximize                                     *
#\***************************************************************************/
const XPRS_OBJ_MINIMIZE              =convert(Cint,  1)
const XPRS_OBJ_MAXIMIZE              =convert(Cint,  -1)

#/***************************************************************************\
# * values related to Set/GetControl/Attribinfo                                  *
#\***************************************************************************/
const XPRS_TYPE_NOTDEFINED               =convert(Cint, 0)
const XPRS_TYPE_INT                      =convert(Cint, 1)
const XPRS_TYPE_INT64                    =convert(Cint, 2)
const XPRS_TYPE_DOUBLE                   =convert(Cint, 3)
const XPRS_TYPE_STRING                   =convert(Cint, 4)

#/***************************************************************************\
# * values related to QCONVEXITY                                            *
#\***************************************************************************/
const XPRS_QCONVEXITY_UNKNOWN              =convert(Cint,    -1 )
const XPRS_QCONVEXITY_NONCONVEX            =convert(Cint,    0 )
const XPRS_QCONVEXITY_CONVEX               =convert(Cint,    1 )
const XPRS_QCONVEXITY_REPAIRABLE           =convert(Cint,    2 )
const XPRS_QCONVEXITY_CONVEXCONE           =convert(Cint,    3 )
const XPRS_QCONVEXITY_CONECONVERTABLE      =convert(Cint,    4 )


#/****************************************************************************\
# * values of bit flags for MipSolPool Solution                              *
#\****************************************************************************/
#const XPRS_ISUSERSOLUTION                 0x1
#const XPRS_ISREPROCESSEDUSERSOLUTION      0x2


# CONTROLS LISTS
const XPRS_STR_CONTROLS = Cint[
6001,
6002,
6003,
6004,
6005
]

const XPRS_DBL_CONTROLS = Cint[
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

const XPRS_INT_CONTROLS = Cint[
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
