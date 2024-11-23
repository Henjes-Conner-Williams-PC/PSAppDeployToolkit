﻿using System;
using System.Net;
using System.Security.Principal;

namespace PSADT.WTSSession
{
    public class ExtendedSessionInfo
    {
        public long SessionId { get; set; }
        public string SessionName { get; set; } = string.Empty;
        public string ConnectionState { get; set; } = string.Empty;
        public NTAccount NTAccount { get; set; } = new NTAccount("");
        public string DomainName { get; set; } = string.Empty;
        public string UserName { get; set; } = string.Empty;
        public SecurityIdentifier Sid { get; set; } = new SecurityIdentifier(WellKnownSidType.NullSid, null);
        public DateTime? LogonTime { get; set; }
        public TimeSpan? IdleTime { get; set; }
        public DateTime? DisconnectTime { get; set; }
        public string ClientName { get; set; } = string.Empty;
        public string ClientProtocolType { get; set; } = string.Empty;
        public string ClientDirectory { get; set; } = string.Empty;
        public long ClientBuildNumber { get; set; }
        public IPAddress ClientIPAddress { get; set; } = IPAddress.None;
        public string ClientIPAddressFamily { get; set; } = string.Empty;
        public IPAddress SessionIPAddress { get; set; } = IPAddress.None;
        public uint HorizontalResolution { get; set; }
        public uint VerticalResolution { get; set; }
        public uint ColorDepth { get; set; }
        public bool? IsRemoteSession { get; set; } = null;

        /// <summary>
        /// Initializes a new instance of the <see cref="ExtendedSessionInfo"/> class.
        /// </summary>
        public ExtendedSessionInfo()
        {
        }
    }
}
