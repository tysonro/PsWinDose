function Get-CheatSheetIpv4 {
<#
.SYNOPSIS
Get Ipv4 Cheat Sheet

.DESCRIPTION
Ipv4 Cheat Sheet will return helpful Ipv4 related information

.EXAMPLE
Get-CheatSheetIpv4
#>
    [CmdletBinding()]
    Param()

    $cheat = @'
    CIDR    Mask        # of Networks   #  of Hosts
    /1      128.0.0.0       128 A       2,147,483,392
    /2      192.0.0.0       64          1,073,741,696
    /3      224.0.0.0       32          536,870,848
    /4      240.0.0.0       16          268,435,424
    /5      248.0.0.0       8 A         134,217,712
    /6      252.0.0.0       4 A         67,108,856
    /7      254.0.0.0       2 A         33,554,428
    /8      255.0.0.0       1 A         16,777,214
    /9      255.128.0.0     128 B       8,388,352
    /10     255.192.0.0     64 B        4,194,176
    /11     255.224.0.0     32 B        2,097,088
    /12     255.240.0.0     16 B        1,048,544
    /13     255.248.0.0     8 B         524,772
    /14     255.252.0.0     4 B         262,136
    /15     255.254.0.0     2 B         131,068
    /16     255.255.0.0     1 B         65,024
    /17     255.255.128.0   128 C       32,512
    /18     255.255.192.0   64 C        16,256
    /19     255.255.224.0   32 C        8,128
    /20     255.255.240.0   16 C        4,064
    /21     255.255.248.0   8 C         2,032
    /22     255.255.252.0   4 C         1,016
    /23     255.255.254.0   2 C         508
    /24     255.255.255.0   1 C         254
    /25     255.255.255.128 2 subnets   124
    /26     255.255.255.192	4 subnets   62
    /27     255.255.255.224	8 subnets   30
    /28     55.255.255.240	16 subnets  14
    /29     255.255.255.248	32          6
    /30     255.255.255.252	64          2
    /31     255.255.255.254	none        none
    /32     255.255.255.255	none        1

    ***Address Scopes***
    127.0.0.0       Loopback
    0.0.0.0         Default Route
    224.0.0.0       Local Multicast (well-known)
    224.0.1.0       Internetwork control
    232.0.0.0       Source-specific multicast
    239.0.0.0       Admin-scopped Multicast


    Binary      0   0   0   0   0   0   0   0
    Decimal     128	64  32  16  8   4   2   1

    Decimal     8 Bit Binary        Binary
    2           0 0 0 0 0 0 1 0     10
    37          0 0 1 0 0 1 0 1     100101
    98          0 1 1 0 0 0 1 0     1100010
    200         1 1 0 0 1 0 0 0     11001000
    255         1 1 1 1 1 1 1 1     11111111

    ***Ports and Services***
    Link-Local          Multicast Name Resolution (LLMNR)
    LLMNR uses          224.0.0.252 on UDP/TCP/5355
    mdnsresponder       Multicast Name Resolution (Multicast DNS Responder IPC)
    mdnsresponder uses  224.0.0.251 on UDP/TCP/5354

    DHCP Client = UDP/68
    DHCP Server = UDP/67
'@
    # return string
    "`n $cheat `n"
}
New-Alias cheat-ipv4 Get-CheatSheetIpv4
