#
# CONFIGURATION FOR AFPD (Netatalk 2.x)
#
# Each single line defines a virtual server that should be available.
# Though, using "\" character, newline escaping is supported.
# Empty lines and lines beginning with `#' are ignored.
# Options in this file will override both compiled-in defaults
# and command line options.
#


#
# Format:
#  - [options]               to specify options for the default server
#  "Server name" [options]   to specify an additional server
#


#
# The following options are available:
#   Transport Protocols:
#     -[no]tcp       Make "AFP over TCP" [not] available
#     -[no]ddp       Make "AFP over AppleTalk" [not] available.
#                    If you have -proxy specified, specify -uamlist "" to 
#                    prevent ddp connections from working.
#
#     -transall      Make both available
#
#   Transport Options:
#     -ipaddr <ipaddress> Specifies the IP address that the server should
#                         advertise and listens to. The default is advertise
#                         the first IP address of the system, but to listen
#                         for any incoming request. The network address may
#                         be specified either in dotted-decimal format for
#                         IPv4 or in hexadecimal format for IPv6.
#                         This option also allows to use one machine to
#                         advertise the AFP-over-TCP/IP settings of another
#                         machine via NBP when used together with the -proxy
#                         option.
#     -server_quantum <number> 
#                         Specifies the DSI server quantum. The minimum
#                         value is 1MB. The max value is 0xFFFFFFFF. If you 
#                         specify a value that is out of range, you'll get 
#                         the default value (currently the minimum).
#     -admingroup <groupname>
#                         Specifies the group of administrators who should
#                         all be seen as the superuser when they log in.
#                         Default is disabled.
#     -ddpaddr x.y        Specifies the DDP address of the server.
#                         the  default is to auto-assign an address (0.0).
#                         this is only useful if you're running on
#                         a multihomed host.
#     -port <number>      Specifies the TCP port the server should respond
#                         to (default is 548)
#     -fqdn <name:port>   specify a fully-qualified domain name (+optional
#                         port). this gets discarded if the server can't
#                         resolve it. this is not honored by appleshare
#                         clients <= 3.8.3 (default: none)
#     -hostname <name>    Use this instead of the result from calling
#                         hostname for dertermening which IP address to
#                         advertise, therfore the hostname is resolved to
#                         an IP which is the advertised. This is NOT used for
#                         listening and it is also overwritten by -ipaddr.
#     -proxy              Run an AppleTalk proxy server for specified
#                         AFP/TCP server (if address/port aren't given,
#                         then first IP address of the system/548 will
#                         be used).
#                         if you don't want the proxy server to act as
#                         a ddp server as well, set -uamlist to an empty
#                         string.
#     -dsireadbuf [number]
#                         Scale factor that determines the size of the
#                         DSI/TCP readahead buffer, default is 12. This is
#                         multiplies with the DSI server quantum (default
#                         ~300k) to give the size of the buffer. Increasing
#                         this value might increase throughput in fast local
#                         networks for volume to volume copies.  Note: This
#                         buffer is allocated per afpd child process, so
#                         specifying large values will eat up large amount of
#                         memory (buffer size * number of clients).
#     -tcprcvbuf [number]
#                         Try to set TCP receive buffer using setsockpt().
#                         Often OSes impose restrictions on the applications
#                         ability to set this value.
#     -tcpsndbuf [number]
#                         Try to set TCP send buffer using setsockpt().
#                         Often OSes impose restrictions on the applications
#                         ability to set this value.
#     -slp                Register this server with the Service Location
#                         Protocol (if SLP support was compiled in).
#     -nozeroconf         Don't register this server with the Multicats
#                         DNS Protocol.
#     -advertise_ssh      Allows Mac OS X clients (10.3.3-10.4) to
#                         automagically establish a tunneled AFP connection
#                         through SSH. This option is not so significant
#                         for the recent Mac OS X. See the Netatalk Manual
#                         in detail.
#
#
#   Authentication Methods:
#     -uampath <path>  Use this path to look for User Authentication Modules.
#                      (default: /usr/lib/netatalk)
#     -uamlist <a,b,c> Comma-separated list of UAMs.
#                      (default: uams_dhx.so,uams_dhx2.so)
#
#                      some commonly available UAMs:
#                      uams_guest.so: Allow guest logins
#
#                      uams_clrtxt.so: (uams_pam.so or uams_passwd.so)
#                                     Allow logins with passwords
#                                     transmitted in the clear. 
#
#                      uams_randnum.so: Allow Random Number and Two-Way
#                                      Random Number exchange for
#                                      authentication.
#
#                      uams_dhx.so: (uams_dhx_pam.so or uams_dhx_passwd.so)
#                                  Allow Diffie-Hellman eXchange
#                                  (DHX) for authentication.
#
#                      uams_dhx2.so: (uams_dhx2_pam.so or uams_dhx2_passwd.so)
#                                   Allow Diffie-Hellman eXchange 2
#                                   (DHX2) for authentication.
#
#   Password Options:
#     -[no]savepassword   [Don't] Allow clients to save password locally
#     -passwdfile <path>  Use this path to store Randnum passwords.
#                         (Default: /etc/netatalk/afppasswd. The only other
#                         useful value is ~/.passwd. See 'man afppasswd'
#                         for details.)
#     -passwdminlen <#>   minimum password length. may be ignored.
#     -[no]setpassword    [Don't] Allow clients to change their passwords.
#     -loginmaxfail <#>   maximum number of failed logins. this may be
#                         ignored if the uam can't handle it.
#
#   AppleVolumes files:
#     -defaultvol <path>  Specifies path to AppleVolumes.default file
#                         (default /etc/netatalk/AppleVolumes.default,
#                         same as -f on command line)
#     -systemvol <path>   Specifies path to AppleVolumes.system file
#                         (default /etc/netatalk/AppleVolumes.system,
#                         same as -s on command line)
#     -[no]uservolfirst   [Don't] read the user's ~/AppleVolumes or
#                         ~/.AppleVolumes before reading
#                         /etc/netatalk/AppleVolumes.default
#                         (same as -u on command line)
#     -[no]uservol        [Don't] Read the user's volume file
#     -closevol           Immediately unmount volumes removed from
#                         AppleVolumes files on SIGHUP sent to the afp
#                         master process.
#
#   Miscellaneous:
#     -authprintdir <path> Specifies the path to be used (per server) to 
#                          store the files required to do CAP-style
#                          print authentication which papd will examine
#                          to determine if a print job should be allowed.
#                          These files are created at login and if they
#                          are to be properly removed, this directory
#                          probably needs to be umode 1777
#     -guestname "user"   Specifies the user name for the guest login
#                         (default "nobody", same as -g on command line)
#     -loginmesg "Message"  Client will display "Message" upon logging in
#                         (no default, same as -l "Message" on commandline)
#     -nodebug            Switch off debugging
#     -client_polling     With this switch enabled, afpd won't advertise
#                         that it is capable of server notifications, so that
#                         connected clients poll the server every 10 seconds
#                         to detect changes in opened server windows.
#                         Note: Depending on the number of simultaneously
#                         connected clients and the network's speed, this can
#                         lead to a significant higher load on your network!
#     -sleep   <number>   AFP 3.x wait number hours before disconnecting
#                         clients in sleep mode. Default 10 hours
#     -tickleval <number> Specify the tickle timeout interval (in seconds).
#                         Note, this defaults to 30 seconds, and really 
#                         shouldn't be changed.  If you want to control
#                         the server idle timeout, use the -timeout option.
#     -timeout <number>   Specify the number of tickles to send before
#                         timing out a connection.
#                         The default is 4, therefore a connection will
#                         timeout in 2 minutes.
#     -[no]icon           [Don't] Use the platform-specific icon. Recent
#                         Mac OS don't display it any longer.
#     -volnamelen <number>
#                         Max length of UTF8-MAC volume name for Mac OS X.
#                         Note that Hangul is especially sensitive to this.
#                           255: limit of spec
#                           80:  limit of generic Mac OS X (default)
#                           73:  limit of Mac OS X 10.1, if >= 74
#                                Finder crashed and restart repeatedly.
#                         Mac OS 9 and earlier is not influenced by this,
#                         Maccharset volume names are always limitted to 27.
#     -[un]setuplog "<logtype> <loglevel> [<filename>]"
#                         Specify that any message of a loglevel up to the
#                         given loglevel should be logged to the given file.
#                         If the filename is ommited the loglevel applies to
#                         messages passed to syslog.
#
#                         By default (no explicit -setuplog and no buildtime
#                         configure flag --with-logfile) afpd logs to syslog
#                         with a default logging setup equivalent to
#                         "-setuplog default log_info".
#
#                         If build with --with-logfile[=somefile]
#                         (default logfile /var/log/netatalk.log) afpd
#                         defaults to a setup that is equivalent to
#                         "-setuplog default log_info [netatalk.log|somefile]"
#
#                         logtypes:  Default, AFPDaemon, Logger, UAMSDaemon
#                         loglevels: LOG_SEVERE, LOG_ERROR, LOG_WARN,
#                                    LOG_NOTE, LOG_INFO, LOG_DEBUG,
#                                    LOG_DEBUG6, LOG_DEBUG7, LOG_DEBUG8,
#                                    LOG_DEBUG9, LOG_MAXDEBUG
#
#                Example: Useful default config
#                         -setuplog "default log_info /var/log/afpd.log"
#
#                         Debugging config
#                         -setuplog "default log_maxdebug /var/log/afpd.log"
#
#     -signature { user:<text> | auto }
#                         Specify a server signature. This option is useful
#                         while running multiple independent instances of
#                         afpd on one machine (e.g. in clustered environments,
#                         to provide fault isolation etc.).
#                         Default is "auto".
#                         "auto" signature type allows afpd generating
#                         signature and saving it to afp_signature.conf
#                         automatically (based on random number).
#                         "host" signature type switches back to "auto"
#                         because it is obsoleted.
#                         "user" signature type allows administrator to
#                         set up a signature string manually.
#                         Examples: three servers running on one machine:
#                               first   -signature user:USERS
#                               second  -signature user:USERS
#                               third   -signature user:ADMINS
#                         First two servers will act as one logical AFP
#                         service. If user logs in to first one and then
#                         connects to second one, session will be
#                         automatically redirected to the first one. But if
#                         client connects to first and then to third, 
#                         will be asked for password twice and will see
#                         resources of both servers.
#                         Traditional method of signature generation causes
#                         two independent afpd instances to have the same
#                         signature and thus cause clients to be redirected
#                         automatically to server (s)he logged in first.
#     -k5keytab <path>
#     -k5service <service>
#     -k5realm <realm>
#                         These are required if the server supports
#                         Kerberos 5 authentication
#     -ntdomain
#     -ntseparator
#                         Use for e.g. winbind authentication, prepends
#                         both strings before the username from login and
#                         then tries to authenticate with the result
#                         through the available and active UAM authentication
#                         modules.
#     -dircachesize entries
#                         Maximum possible entries in the directory cache.
#                         The cache stores directories and files. It is used
#                         to cache the full path to directories and CNIDs
#                         which considerably speeds up directory enumeration.
#                         Default size is 8192, maximum size is 131072. Given
#                         value is rounded up to nearest power of 2. Each
#                         entry takes about 100 bytes, which is not much, but
#                         remember that every afpd child process for every
#                         connected user has its cache.
#     -fcelistener host[:port]
#                         Enables sending FCE events to the specified host,
#                         default port is 12250 if not specified. Specifying
#                         mutliple listeners is done by having this option
#                         once for each of them.
#     -fceevents fmod,fdel,ddel,fcre,dcre,tmsz
#                         Speficies which FCE events are active, default is
#                         fmod,fdel,ddel,fcre,dcre.
#     -fcecoalesce all|delete|create
#                         Coalesce FCE events.
#     -fceholdfmod seconds
#                         This determines the time delay in seconds which is
#                         always waited if another file modification for the
#                         same file is done by a client before sending an FCE
#                         file modification event (fmod). For example saving
#                         a file in Photoshop would generate multiple events
#                         by itself because the application is opening,
#                         modifying and closing a file mutliple times for
#                         every "save". Defautl: 60 seconds.
#     -keepsessions       Enable "Continuous AFP Service". This means the
#                         ability to stop the master afpd process with a
#                         SIGQUIT signal, possibly install an afpd update and
#                         start the afpd process. Existing AFP sessions afpd
#                         processes will remain unaffected. Technically they
#                         will be notified of the master afpd shutdown, sleep
#                         15-20 seconds and then try to reconnect their IPC
#                         channel to the master afpd process. If this
#                         reconnect fails, the sessions are in an undefined
#                         state. Therefor it's absolutely critical to restart
#                         the master process in time!
#     -noacl2maccess      Don't map filesystem ACLs to effective permissions.
#
#   Codepage Options:
#     -unixcodepage <CODEPAGE>  Specifies the servers unix codepage,
#                               e.g. "ISO-8859-15" or "UTF8".
#                               This is used to convert strings to/from
#                               the systems locale, e.g. for authenthication.
#                               Defaults to LOCALE if your system supports it,
#                               otherwise ASCII will be used.
#
#     -maccodepage <CODEPAGE>   Specifies the legacy clients (<= Mac OS 9)
#                               codepage, e.g. "MAC_ROMAN".
#                               This is used to convert strings to the
#                               systems locale, e.g. for authenthication
#                               and SIGUSR2 messaging. This will also be
#                               the default for volumes maccharset.
#
#   CNID related options:
#     -cnidserver <ipaddress:port>
#                               Specifies the IP address and port of a
#                               cnid_metad server, required for CNID dbd
#                               backend. Defaults to localhost:4700.
#                               The network address may be specified either
#                               in dotted-decimal format for IPv4 or in
#                               hexadecimal format for IPv6.
#
#   Avahi (Bonjour) related options:
#     -mimicmodel <model>
#                               Specifies the icon model that appears on
#                               clients. Defaults to off. Examples: RackMac
#                               (same as Xserve), PowerBook, PowerMac, Macmini,
#                               iMac, MacBook, MacBookPro, MacBookAir, MacPro,
#                               AppleTV1,1, AirPort
#


#
# Some examples:
#
#       The simplest case is to not have an afpd.conf.
#
#       4 servers w/ names server1-3 and one w/ the hostname. servers
#       1-3 get routed to different ports with server 3 being bound 
#       specifically to address 192.168.1.3
#
#           -
#           server1 -port 12000
#           server2 -port 12001
#           server3 -port 12002 -ipaddr 192.168.1.3
#
#       a dedicated guest server, a user server, and a special
#       AppleTalk-only server:
#
#           "Guest Server" -uamlist uams_guest.so \
#                   -loginmesg "Welcome guest! I'm a public server."
#           "User Server" -uamlist uams_dhx2.so -port 12000
#           "special" -ddp -notcp -defaultvol <path> -systemvol <path>
#


# default:
# - -tcp -noddp -uamlist uams_dhx.so,uams_dhx2.so
- -transall -icon -mimicmodel PowerMac
