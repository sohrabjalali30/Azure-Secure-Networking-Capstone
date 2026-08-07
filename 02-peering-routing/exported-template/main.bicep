param virtualNetworks_vnet_29670_name string = 'vnet-29670'
param publicIPAddresses_pip_29670_name string = 'pip-29670'
param virtualNetworks_vnet_hub_az104_name string = 'vnet-hub-az104'
param networkSecurityGroups_nsg_29670_name string = 'nsg-29670'
param virtualNetworks_vnet_spoke_az104_name string = 'vnet-spoke-az104'
param routeTables_rt_spoke_forced_routing_name string = 'rt-spoke-forced-routing'

resource networkSecurityGroups_nsg_29670_name_resource 'Microsoft.Network/networkSecurityGroups@2025-07-01' = {
  name: networkSecurityGroups_nsg_29670_name
  location: 'eastus'
  properties: {
    securityRules: [
      {
        name: 'rdp_rule'
        id: networkSecurityGroups_nsg_29670_name_rdp_rule.id
        properties: {
          description: 'Locks inbound down to rdp default port 3389.'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 124
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
    ]
  }
}

resource publicIPAddresses_pip_29670_name_resource 'Microsoft.Network/publicIPAddresses@2025-07-01' = {
  name: publicIPAddresses_pip_29670_name
  location: 'eastus'
  sku: {
    name: 'Basic'
    tier: 'Regional'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Dynamic'
    idleTimeoutInMinutes: 4
    dnsSettings: {
      domainNameLabel: 'vm1fqdn-29670'
      fqdn: 'vm1fqdn-29670.eastus.cloudapp.azure.com'
    }
    ipTags: []
  }
}

resource routeTables_rt_spoke_forced_routing_name_resource 'Microsoft.Network/routeTables@2025-07-01' = {
  name: routeTables_rt_spoke_forced_routing_name
  location: 'eastus'
  properties: {
    disableBgpRoutePropagation: false
    routes: [
      {
        name: 'default-to-nva'
        id: routeTables_rt_spoke_forced_routing_name_default_to_nva.id
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: '10.20.1.4'
        }
      }
    ]
  }
}

resource networkSecurityGroups_nsg_29670_name_rdp_rule 'Microsoft.Network/networkSecurityGroups/securityRules@2025-07-01' = {
  name: '${networkSecurityGroups_nsg_29670_name}/rdp_rule'
  properties: {
    description: 'Locks inbound down to rdp default port 3389.'
    protocol: 'Tcp'
    sourcePortRange: '*'
    destinationPortRange: '3389'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 124
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
  dependsOn: [
    networkSecurityGroups_nsg_29670_name_resource
  ]
}

resource routeTables_rt_spoke_forced_routing_name_default_to_nva 'Microsoft.Network/routeTables/routes@2025-07-01' = {
  name: '${routeTables_rt_spoke_forced_routing_name}/default-to-nva'
  properties: {
    addressPrefix: '0.0.0.0/0'
    nextHopType: 'VirtualAppliance'
    nextHopIpAddress: '10.20.1.4'
  }
  dependsOn: [
    routeTables_rt_spoke_forced_routing_name_resource
  ]
}

resource virtualNetworks_vnet_29670_name_resource 'Microsoft.Network/virtualNetworks@2025-07-01' = {
  name: virtualNetworks_vnet_29670_name
  location: 'eastus'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: [
      {
        name: 'user-subnet'
        id: virtualNetworks_vnet_29670_name_user_subnet.id
        properties: {
          addressPrefix: '10.0.0.0/24'
          networkSecurityGroup: {
            id: networkSecurityGroups_nsg_29670_name_resource.id
          }
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        name: 'server-subnet'
        id: virtualNetworks_vnet_29670_name_server_subnet.id
        properties: {
          addressPrefix: '10.0.1.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

resource virtualNetworks_vnet_hub_az104_name_resource 'Microsoft.Network/virtualNetworks@2025-07-01' = {
  name: virtualNetworks_vnet_hub_az104_name
  location: 'eastus'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.20.0.0/16'
      ]
    }
    summarizedGatewayPrefixes: {
      addressPrefixes: []
    }
    encryption: {
      enabled: false
      enforcement: 'AllowUnencrypted'
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: [
      {
        name: 'NVA-Subnet'
        id: virtualNetworks_vnet_hub_az104_name_NVA_Subnet.id
        properties: {
          addressPrefixes: [
            '10.20.1.0/24'
          ]
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          defaultOutboundAccess: false
        }
      }
    ]
    virtualNetworkPeerings: [
      {
        name: 'Spoke-to-Hub'
        id: virtualNetworks_vnet_hub_az104_name_Spoke_to_Hub.id
        properties: {
          peeringState: 'Connected'
          peeringSyncLevel: 'FullyInSync'
          remoteVirtualNetwork: {
            id: virtualNetworks_vnet_spoke_az104_name_resource.id
          }
          allowVirtualNetworkAccess: true
          allowForwardedTraffic: false
          allowGatewayTransit: false
          useRemoteGateways: false
          doNotVerifyRemoteGateways: false
          peerCompleteVnets: true
          enableOnlyIPv6Peering: false
          remoteAddressSpace: {
            addressPrefixes: [
              '10.30.0.0/16'
            ]
          }
          remoteVirtualNetworkAddressSpace: {
            addressPrefixes: [
              '10.30.0.0/16'
            ]
          }
        }
      }
    ]
    enableDdosProtection: false
  }
}

resource virtualNetworks_vnet_spoke_az104_name_default 'Microsoft.Network/virtualNetworks/subnets@2025-07-01' = {
  name: '${virtualNetworks_vnet_spoke_az104_name}/default'
  properties: {
    addressPrefixes: [
      '10.30.0.0/24'
    ]
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    defaultOutboundAccess: false
  }
  dependsOn: [
    virtualNetworks_vnet_spoke_az104_name_resource
  ]
}

resource virtualNetworks_vnet_hub_az104_name_NVA_Subnet 'Microsoft.Network/virtualNetworks/subnets@2025-07-01' = {
  name: '${virtualNetworks_vnet_hub_az104_name}/NVA-Subnet'
  properties: {
    addressPrefixes: [
      '10.20.1.0/24'
    ]
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    defaultOutboundAccess: false
  }
  dependsOn: [
    virtualNetworks_vnet_hub_az104_name_resource
  ]
}

resource virtualNetworks_vnet_29670_name_server_subnet 'Microsoft.Network/virtualNetworks/subnets@2025-07-01' = {
  name: '${virtualNetworks_vnet_29670_name}/server-subnet'
  properties: {
    addressPrefix: '10.0.1.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_vnet_29670_name_resource
  ]
}

resource virtualNetworks_vnet_spoke_az104_name_resource 'Microsoft.Network/virtualNetworks@2025-07-01' = {
  name: virtualNetworks_vnet_spoke_az104_name
  location: 'eastus'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.30.0.0/16'
      ]
    }
    encryption: {
      enabled: false
      enforcement: 'AllowUnencrypted'
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: [
      {
        name: 'default'
        id: virtualNetworks_vnet_spoke_az104_name_default.id
        properties: {
          addressPrefixes: [
            '10.30.0.0/24'
          ]
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          defaultOutboundAccess: false
        }
      }
      {
        name: 'App-Subnet'
        id: virtualNetworks_vnet_spoke_az104_name_App_Subnet.id
        properties: {
          addressPrefixes: [
            '10.30.1.0/24'
          ]
          routeTable: {
            id: routeTables_rt_spoke_forced_routing_name_resource.id
          }
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          defaultOutboundAccess: false
        }
      }
    ]
    virtualNetworkPeerings: [
      {
        name: 'Hub-to-Spoke'
        id: virtualNetworks_vnet_spoke_az104_name_Hub_to_Spoke.id
        properties: {
          peeringState: 'Connected'
          peeringSyncLevel: 'FullyInSync'
          remoteVirtualNetwork: {
            id: virtualNetworks_vnet_hub_az104_name_resource.id
          }
          allowVirtualNetworkAccess: true
          allowForwardedTraffic: false
          allowGatewayTransit: false
          useRemoteGateways: false
          doNotVerifyRemoteGateways: false
          peerCompleteVnets: true
          enableOnlyIPv6Peering: false
          remoteAddressSpace: {
            addressPrefixes: [
              '10.20.0.0/16'
            ]
          }
          remoteVirtualNetworkAddressSpace: {
            addressPrefixes: [
              '10.20.0.0/16'
            ]
          }
        }
      }
    ]
    enableDdosProtection: false
  }
}

resource virtualNetworks_vnet_spoke_az104_name_App_Subnet 'Microsoft.Network/virtualNetworks/subnets@2025-07-01' = {
  name: '${virtualNetworks_vnet_spoke_az104_name}/App-Subnet'
  properties: {
    addressPrefixes: [
      '10.30.1.0/24'
    ]
    routeTable: {
      id: routeTables_rt_spoke_forced_routing_name_resource.id
    }
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    defaultOutboundAccess: false
  }
  dependsOn: [
    virtualNetworks_vnet_spoke_az104_name_resource
  ]
}

resource virtualNetworks_vnet_29670_name_user_subnet 'Microsoft.Network/virtualNetworks/subnets@2025-07-01' = {
  name: '${virtualNetworks_vnet_29670_name}/user-subnet'
  properties: {
    addressPrefix: '10.0.0.0/24'
    networkSecurityGroup: {
      id: networkSecurityGroups_nsg_29670_name_resource.id
    }
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_vnet_29670_name_resource
  ]
}

resource virtualNetworks_vnet_spoke_az104_name_Hub_to_Spoke 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2025-07-01' = {
  name: '${virtualNetworks_vnet_spoke_az104_name}/Hub-to-Spoke'
  properties: {
    peeringState: 'Connected'
    peeringSyncLevel: 'FullyInSync'
    remoteVirtualNetwork: {
      id: virtualNetworks_vnet_hub_az104_name_resource.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    doNotVerifyRemoteGateways: false
    peerCompleteVnets: true
    enableOnlyIPv6Peering: false
    remoteAddressSpace: {
      addressPrefixes: [
        '10.20.0.0/16'
      ]
    }
    remoteVirtualNetworkAddressSpace: {
      addressPrefixes: [
        '10.20.0.0/16'
      ]
    }
  }
  dependsOn: [
    virtualNetworks_vnet_spoke_az104_name_resource
  ]
}

resource virtualNetworks_vnet_hub_az104_name_Spoke_to_Hub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2025-07-01' = {
  name: '${virtualNetworks_vnet_hub_az104_name}/Spoke-to-Hub'
  properties: {
    peeringState: 'Connected'
    peeringSyncLevel: 'FullyInSync'
    remoteVirtualNetwork: {
      id: virtualNetworks_vnet_spoke_az104_name_resource.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    doNotVerifyRemoteGateways: false
    peerCompleteVnets: true
    enableOnlyIPv6Peering: false
    remoteAddressSpace: {
      addressPrefixes: [
        '10.30.0.0/16'
      ]
    }
    remoteVirtualNetworkAddressSpace: {
      addressPrefixes: [
        '10.30.0.0/16'
      ]
    }
  }
  dependsOn: [
    virtualNetworks_vnet_hub_az104_name_resource
  ]
}
