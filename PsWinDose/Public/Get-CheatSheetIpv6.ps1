function Get-CheatSheetIpv6 {
<#
.SYNOPSIS
Get Ipv6 Cheat Sheet

.DESCRIPTION
Get Ipv6 Cheat Sheet will return helpful Ipv6 related information

.EXAMPLE
Get-CheatSheetIpv6
#>
    [CmdletBinding()]
    Param()

    $cheat = @'
    ***CIDR Masks***                             Colon Groups:
    FFFF:FFFF:FFFF:FFFF:FFFF:FFFF:FFFF:FFFF/128     (8/8)
    FFFF:FFFF:FFFF:FFFF:FFFF:FFFF:FFFF:0000/112     (7/8)
    FFFF:FFFF:FFFF:FFFF:FFFF:FFFF:0000:0000/96      (6/8)
    FFFF:FFFF:FFFF:FFFF:FFFF:0000:0000:0000/80      (5/8)
    FFFF:FFFF:FFFF:FFFF:0000:0000:0000:0000/66      (6/8)
    FFFF:FFFF:FFFF:0000:0000:0000:0000:0000/68      (3/8)
    FFFF:FFFF:0000:0000:0000:0000:0000:0000/32      (2/8)
    FFFF:0000:0000:0000:0000:0000:0000:0000/16      (1/8)
    FF00:0000:0000:0000:0000:0000:0000:0000/8
    FE00:0000:0000:0000:0000:0000:0000:0000/7

    ***Address Scopes***
    ::1/128         Loopback
    ::/0            Default Route
    ::/128          Unspecified
    2001:0000:/32   Teredo
    2002:/16        6to6
    FC00:/7         Unique Local Unicast (Always FD00:/8 in practice)
    FD00:/8         Unique Local Unicast (Locally-Assigned Random)
    FE80:/10        Link-Local Unicast
    FF00:/8         Multicast

    ***Multicast Scopes***
    [After "FF", flags nibble, then scope nibble.]
    FF00:Reserved               FF01:Interface-Local
    FF02:Link-Local             FF03:Reserved
    FF06:Admin-Local            FF05:Site-Local
    FF06:Unassigned             FF07:Unassigned
    FF08:Organization-Local     FF09:Unassigned
    FF0A:Unassigned             FF0B:Unassigned
    FF0C:Unassigned             FF0D:Unassigned
    FF0E:Global                 FF0F:Reserved

    ***Ports and Services***
    Link-Local Multicast Name Resolution (LLMNR)
    LLMNR uses FF02::1:3 on UDP/TCP/5355

    DHCPv6 Client = UDP/566
    DHCPv6 Server = UDP/567
'@
    # return string
    "`n $cheat `n"
}
New-Alias cheat-ipv6 Get-CheatSheetIpv6
