/system script
add dont-require-permissions=no name=failoverScript owner=admin policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=":\
    global upname \"Kyivstar\";\
    \n:global downname \"Life\";\
    \n:global rname [/system identity get name];\
    \n:global currentslot [/system routerboard modem get sim-slot];\
    \n:global inittimeout \"60\";\
    \n:global connecttimeout \"60\";\
    \n:global minsignallevel \"-110\";\
    \n:global currentsignallevel;\
    \n\
    \n#function notification telegram\? (1 - yes, 0 - no)\
    \n:global notification \"1\";\
    \n:global telegrambotid \"botid\"\
    ;\
    \n:global telegramclientid \"clientid\";\
    \n\
    \n#function ping\? (1 - yes, 0 - no)\
    \n:global ping \"1\";\
    \n:global pingip \"1.1.1.1\";\
    \n:global pingipcontrol \"8.8.8.8\";\
    \n:global pingcount \"5\";\
    \n:global pingminpackage \"30\";\
    \n\
    \n#function change sim\? (1 - yes, 0 - no)\
    \n:global changesim \"1\";\
    \n\
    \n#function logging\? (1 - yes, 0 - no)\
    \n:global logging \"1\";\
    \n:global prefixlog \">>> \";\
    \n\
    \n:if ([\$notification] = 1) do={\
    \n    :global notification do={\
    \n        :global telegrambotid;\
    \n        :global telegramclientid;\
    \n        :global rname;\
    \n        :global currentsignallevel;\
    \n                        \
    \n        :local tmessage (\"https://api.telegram.org/bot\" . \$telegrambo\
    tid . \"/sendMessage\?chat_id=\" . \$telegramclientid . \"&text=\" . \$rna\
    me . \" Current signal \" . \$currentsignallevel . \" Change SIM\");\
    \n                            \
    \n        /tool fetch mode=https url=\$tmessage output=none;\
    \n    }\
    \n}\
    \n\
    \n:if ([\$changesim] = 1) do={\
    \n    :global changesim do={\
    \n        :global currentslot;\
    \n        :global upname;\
    \n        :global downname;\
    \n        :global prefixlog;\
    \n        :global logging;\
    \n                            \
    \n        :if (\$currentslot = \"up\") do={\
    \n            :if (\$logging = \"1\") do={\
    \n                :log info message=(\$prefixlog . \"Change sim to \" . \$\
    downname);\
    \n            }\
    \n\
    \n            /system routerboard modem set sim-slot=down;\
    \n                                                                        \
    \n        } else={\
    \n            :if (\$logging = \"1\") do={\
    \n                :log info message=(\$prefixlog . \"Change sim to \" . \$\
    upname);\
    \n            }\
    \n                                                                        \
    \_                                   \
    \n            /system routerboard modem set sim-slot=up;\
    \n                                                                        \
    \_                                       \
    \n        }\
    \n    }\
    \n}\
    \n\
    \n:global initialize do={\
    \n    :global inittimeout;\
    \n    :local i 0;\
    \n    \
    \n    :while (\$i < \$inittimeout) do={\
    \n        :if ([:len [/interface lte find ]] > 0) do={\
    \n            :return true;\
    \n        }\
    \n                        \
    \n        :set \$i (\$i+1);\
    \n        :delay 1s;\
    \n    }\
    \n\
    \n    :return false;\
    \n}\
    \n\
    \n:global waitconnect do={\
    \n    :global connecttimeout;\
    \n    :local i 0;\
    \n    \
    \n    :while (\$i < \$connecttimeout) do={\
    \n        :if ([/interface lte get [find name=\"lte1\"] running] = true) d\
    o={\
    \n            :return true;\
    \n        }\
    \n                        \
    \n        :set \$i (\$i+1);\
    \n        :delay 1s;\
    \n    }\
    \n    \
    \n    :return false;\
    \n}\
    \n\
    \n:if ([\$initialize] = true) do={\
    \n    :if ([\$waitconnect] = true) do={\
    \n        /interface lte info lte1 once do={\
    \n            :if (\$(\"rsrp\")) do={\
    \n                :set currentsignallevel \$(\"rsrp\");\
    \n            } else={\
    \n                :set currentsignallevel \$(\"rssi\");\
    \n            }\
    \n        }\
    \n                                                                \
    \n        :if (\$currentsignallevel < \$minsignallevel) do={\
    \n            :if (\$logging = \"1\") do={\
    \n                :log info message=(\$prefixlog . \"Current signal \" . \
    \$currentsignallevel . \" < \" . \$minsignallevel . \" Change sim.\");\
    \n            }\
    \n                                                                        \
    \_                           \
    \n            \$notification;\
    \n            \$changesim;\
    \n        }\
    \n                                                                        \
    \_                                           \
    \n        :if (\$ping = \"1\") do={\
    \n            :local pingstatus ((( [/ping \$pingip count=\$pingcount] + [\
    /ping \$pingipcontrol count=\$pingcount] ) / (\$pingcount * 2)) * 100);\
    \n\
    \n            :if (\$pingstatus < \$pingminpackage) do={\
    \n                \$changesim;\
    \n            }\
    \n        }\
    \n    } else={\
    \n        :if (\$logging = \"1\") do={\
    \n            :log info message=(\$prefixlog . \"GSM network is not connec\
    ted. Change sim.\");\
    \n        }\
    \n                                                                        \
    \_                                                                        \
    \_                              \
    \n        \$changesim;\
    \n    }\
    \n} else={\
    \n    :if (\$logging = \"1\") do={\
    \n        :log info message=(\$prefixlog . \"LTE modem did not appear, pow\
    er-reset\");\
    \n    }\
    \n        \
    \n    /system routerboard usb power-reset duration=10s;\
    \n}"