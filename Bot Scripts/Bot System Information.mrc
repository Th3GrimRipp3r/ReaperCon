;System Info by Ford_Lawnmower irc.mindforge.org #USA-Chat
;Bot Modification by GrimReaper & Zetacon
;To change:
;1. Add triggers to activate the script for a bot
;2. Perhaps change displayed properties?

on $*:TEXT:/^!(sys|sysinfo|system)$/Si:#: {
  if ($nick isop $chan) { allinfo msg $chan }
}
alias -l allinfo {
  $1- 04S14ystem 04I14nfo: $cpuinfo  $osinfo $videoinfo $moboinfo
  $1- 04S14ystem 04I14nfo: $netinfo $diskinfo
}
alias -l cpuinfo {
  .comopen Processor WbemScripting.SWbemLocator
  if (!$comerr) {
    if ($com(Processor, ConnectServer, 3, dispatch* Specs)) {
      if ($com(Specs, Get, 3, string, Win32_Processor.DeviceID='CPU0', dispatch* Results)) {
        var %manufacturer, %name, %caption, %clockspeed, %load, %architecture
        if ($com(Results, Manufacturer, 3)) { %manufacturer = $com(Results).result }
        if ($com(Results, Name, 3)) { %name = $com(Results).result }
        if ($com(Results, Caption, 3)) { %caption = $com(Results).result }
        if ($com(Results, CurrentClockSpeed, 3)) { %clockspeed = $com(Results).result }
        if ($com(Results, LoadPercentage, 3)) { %load = $com(Results).result }
        if ($com(Results, Architecture, 3)) { %architecture = $com(Results).result }
        .comclose Results
      }
      .comclose Specs
    }
    .comclose Processor
    $iif($isid,return,$iif(# ischan,say,echo -a)) 04C14PU:04 %manufacturer %name  %caption $+(%load,%) Load
  }
  else { echo -st Com Error $nopath($script) | .comclose Processor | return }
}
alias -l osinfo {
  if (!$com(Wbem.2)) { WbemOpen }
  var %TotalMemory 04T14otal 04M14emory:04 $round($calc($WbemGet(Win32_OperatingSystem,TotalVisibleMemorySize,1)/1024),2)
  var %FreeMemory 04A14vailable 04M14emory:04 $round($calc($WbemGet(Win32_OperatingSystem,FreePhysicalMemory,1)/1024),2)
  var %OSCaption 04O14S:04 $WbemGet(Win32_OperatingSystem,Caption,1)
  var %OSVersion $WbemGet(Win32_OperatingSystem,Version,1)
  var %OSArchitecture $WbemGet(Win32_OperatingSystem,OSArchitecture,1)
  if ($com(Wbem.2)) { .comclose Wbem.2 }
  $iif($isid,return,$iif(# ischan,say,echo -a)) %OSCaption %OSVersion %OSArchitecture 04U14ptime:04 $uptime(system,1) $+(%TotalMemory,MB) $+(%FreeMemory,MB)
}
alias -l moboinfo {
  if (!$com(Wbem.2)) { WbemOpen }
  var %Aname 04A14udio:04 $WbemGet(Win32_SoundDevice,Name,1)  
  var %Description $WbemGet(Win32_BaseBoard,Description,1)
  var %Manufacturer $WbemGet(Win32_BaseBoard,Manufacturer,1)
  if ($com(Wbem.2)) { .comclose Wbem.2 }
  $iif($isid,return,$iif(# ischan,say,echo -a)) 04M14OBO:04 %Manufacturer %Description %Aname 
}
alias -l netinfo {
  if (!$com(Wbem.2)) { WbemOpen }
  var %BytesReceived $WbemGet(Win32_PerfRawData_Tcpip_NetworkInterface,BytesReceivedPerSec,1)
  %BytesReceived = 04R14eceived:04 $bytes($calc(%BytesReceived + $WbemGet(Win32_PerfRawData_Tcpip_NetworkInterface,BytesReceivedPerSec,2))).suf
  var %BytesSent $WbemGet(Win32_PerfRawData_Tcpip_NetworkInterface,BytesSentPerSec,1)
  %BytesSent = 04S14ent:04 $bytes($calc(%BytesSent + $WbemGet(Win32_PerfRawData_Tcpip_NetworkInterface,BytesSentPerSec,2))).suf
  var %BytesTotal $WbemGet(Win32_PerfRawData_Tcpip_NetworkInterface,BytesTotalPerSec,1)
  %BytesTotal = 04T14otal:04 $bytes($calc(%BytesTotal + $WbemGet(Win32_PerfRawData_Tcpip_NetworkInterface,BytesTotalPerSec,2))).suf
  var %Bandwidth $WbemGet(Win32_PerfRawData_Tcpip_NetworkInterface,CurrentBandwidth,1)
  %Bandwidth = 04B14andwidth:04 $calc(%Bandwidth + $WbemGet(Win32_PerfRawData_Tcpip_NetworkInterface,CurrentBandwidth,2)/100000)
  var %Name $WbemGet(Win32_PerfRawData_Tcpip_NetworkInterface,Name,1)
  %Name = $+(%Name,14/04,$WbemGet(Win32_PerfRawData_Tcpip_NetworkInterface,Name,2))
  if ($com(Wbem.2)) { .comclose Wbem.2 }
  $iif($isid,return,$iif(# ischan,say,echo -a)) 04N14etwork:04 %Name $+(%Bandwidth,KBps) %BytesReceived %BytesSent %BytesTotal 
}
alias -l videoinfo {
  if (!$com(Wbem.2)) { WbemOpen }
  var %Compatibility $WbemGet(Win32_VideoController,AdapterCompatibility,1)
  var %VideoProcessor $WbemGet(Win32_VideoController,VideoProcessor,1)
  var %AdapterRam $WbemGet(Win32_VideoController,AdapterRam,1)
  var %Horizontal $WbemGet(Win32_VideoController,currenthorizontalresolution,1)
  var %Vertical $WbemGet(Win32_VideoController,currentverticalresolution,1)
  var %Bits $WbemGet(Win32_VideoController,currentbitsperpixel,1)
  var %Refresh $WbemGet(Win32_VideoController,currentrefreshrate,1)
  if ($com(Wbem.2)) { .comclose Wbem.2 }  
  $iif($isid,return,$iif(# ischan,say,echo -a)) 04V14ideo:04 %Compatibility %VideoProcessor $+($bytes(%AdapterRam,3),MB) $+(%Horizontal,x,%Vertical) $+(%Bits,bit) $+(%Refresh,Hz)
}
alias -l DiskInfo {
  var %d $disk(0),%total 0,%free 0,%result
  while (%d) {
    if ($disk(%d).size) {
      %total = $calc(%total + $disk(%d).size)
      %free = $calc(%free + $disk(%d).free)
      %result = %result 04I14D:04 $disk(%d).label $disk(%d).path 04T14ype:04 $disk(%d).type 04S14ize:04 $bytes($disk(%d).size,g3).suf 04F14ree:04 $bytes($disk(%d).free,g3).suf 
    }
    dec %d 
  }
  $iif($isid,return,$iif(# ischan,say,echo -a)) %Result 04T14otal 04D14isk 04S14pace:04 $bytes(%Total,g3).suf 04T14otal 04S14pace 04F14ree:04 $bytes(%free,g3).suf 
}  
alias -l WbemOpen {
  .comopen Wbem.1 WbemScripting.SWbemLocator
  .comclose Wbem.1 $com(Wbem.1,ConnectServer,3,dispatch* Wbem.2)
}
alias -l WbemGet {
  if ($com(Wbem.3)) { .comclose Wbem.3 }
  if ($com(Wbem.2,ExecQuery,3,bstr*,select $2 from $1,dispatch* Wbem.3)) { var %Result $comval(Wbem.3,$3,$2) }
  .comclose Wbem.3 
  return %Result
}
