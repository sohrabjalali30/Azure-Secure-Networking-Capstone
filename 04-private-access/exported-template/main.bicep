param privateEndpoints_P_Storage_name string = 'P-Storage'
param virtualNetworks_VNat_Private_name string = 'VNat-Private'
param storageAccounts_storageshare001_name string = 'storageshare001'
param storageAccounts_storagebackups001_name string = 'storagebackups001'
param privateDnsZones_privatelink_file_core_windows_net_name string = 'privatelink.file.core.windows.net'

resource privateDnsZones_privatelink_file_core_windows_net_name_resource 'Microsoft.Network/privateDnsZones@2024-06-01' = {
  name: privateDnsZones_privatelink_file_core_windows_net_name
  location: 'global'
  properties: {}
}

resource virtualNetworks_VNat_Private_name_resource 'Microsoft.Network/virtualNetworks@2025-07-01' = {
  name: virtualNetworks_VNat_Private_name
  location: 'eastus'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.50.0.0/16'
      ]
    }
    encryption: {
      enabled: false
      enforcement: 'AllowUnencrypted'
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: [
      {
        name: 'Subnet-Private'
        id: virtualNetworks_VNat_Private_name_Subnet_Private.id
        properties: {
          addressPrefixes: [
            '10.50.2.0/24'
          ]
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          defaultOutboundAccess: false
        }
      }
      {
        name: 'Subnet-Client'
        id: virtualNetworks_VNat_Private_name_Subnet_Client.id
        properties: {
          addressPrefixes: [
            '10.50.1.0/24'
          ]
          delegations: [
            {
              name: 'Microsoft.StoragePool/diskPools'
              id: '${virtualNetworks_VNat_Private_name_Subnet_Client.id}/delegations/Microsoft.StoragePool/diskPools'
              properties: {
                serviceName: 'Microsoft.StoragePool/diskPools'
              }
              type: 'Microsoft.Network/virtualNetworks/subnets/delegations'
            }
          ]
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          defaultOutboundAccess: false
        }
      }
    ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

resource storageAccounts_storagebackups001_name_resource 'Microsoft.Storage/storageAccounts@2026-04-01' = {
  name: storageAccounts_storagebackups001_name
  location: 'eastus'
  sku: {
    name: 'StandardV2_GRS'
    tier: 'Standard'
  }
  kind: 'FileStorage'
  properties: {
    dualStackEndpointPreference: {
      publishIpv6Endpoint: false
    }
    dnsEndpointType: 'Standard'
    defaultToOAuthAuthentication: false
    publicNetworkAccess: 'Disabled'
    allowCrossTenantReplication: false
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: true
    largeFileSharesState: 'Enabled'
    networkAcls: {
      ipv6Rules: []
      resourceAccessRules: []
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Deny'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      requireInfrastructureEncryption: false
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
  }
}

resource storageAccounts_storageshare001_name_resource 'Microsoft.Storage/storageAccounts@2026-04-01' = {
  name: storageAccounts_storageshare001_name
  location: 'eastus'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  kind: 'StorageV2'
  properties: {
    dualStackEndpointPreference: {
      publishIpv6Endpoint: false
    }
    dnsEndpointType: 'Standard'
    defaultToOAuthAuthentication: false
    publicNetworkAccess: 'Enabled'
    allowCrossTenantReplication: false
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: true
    networkAcls: {
      ipv6Rules: []
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      requireInfrastructureEncryption: false
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Hot'
  }
}

resource privateDnsZones_privatelink_file_core_windows_net_name_storagebackups001 'Microsoft.Network/privateDnsZones/A@2024-06-01' = {
  parent: privateDnsZones_privatelink_file_core_windows_net_name_resource
  name: 'storagebackups001'
  properties: {
    metadata: {
      creator: 'created by private endpoint P-Storage with resource guid 8c2a4213-3e36-4f57-8f2b-e43d7f5b5c5e'
    }
    ttl: 10
    aRecords: [
      {
        ipv4Address: '10.50.2.4'
      }
    ]
  }
}

resource Microsoft_Network_privateDnsZones_SOA_privateDnsZones_privatelink_file_core_windows_net_name 'Microsoft.Network/privateDnsZones/SOA@2024-06-01' = {
  parent: privateDnsZones_privatelink_file_core_windows_net_name_resource
  name: '@'
  properties: {
    ttl: 3600
    soaRecord: {
      email: 'azureprivatedns-host.microsoft.com'
      expireTime: 2419200
      host: 'azureprivatedns.net'
      minimumTtl: 10
      refreshTime: 3600
      retryTime: 300
      serialNumber: 1
    }
  }
}

resource virtualNetworks_VNat_Private_name_Subnet_Client 'Microsoft.Network/virtualNetworks/subnets@2025-07-01' = {
  name: '${virtualNetworks_VNat_Private_name}/Subnet-Client'
  properties: {
    addressPrefixes: [
      '10.50.1.0/24'
    ]
    delegations: [
      {
        name: 'Microsoft.StoragePool/diskPools'
        id: '${virtualNetworks_VNat_Private_name_Subnet_Client.id}/delegations/Microsoft.StoragePool/diskPools'
        properties: {
          serviceName: 'Microsoft.StoragePool/diskPools'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets/delegations'
      }
    ]
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    defaultOutboundAccess: false
  }
  dependsOn: [
    virtualNetworks_VNat_Private_name_resource
  ]
}

resource virtualNetworks_VNat_Private_name_Subnet_Private 'Microsoft.Network/virtualNetworks/subnets@2025-07-01' = {
  name: '${virtualNetworks_VNat_Private_name}/Subnet-Private'
  properties: {
    addressPrefixes: [
      '10.50.2.0/24'
    ]
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    defaultOutboundAccess: false
  }
  dependsOn: [
    virtualNetworks_VNat_Private_name_resource
  ]
}

resource storageAccounts_storageshare001_name_default 'Microsoft.Storage/storageAccounts/blobServices@2026-04-01' = {
  parent: storageAccounts_storageshare001_name_resource
  name: 'default'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    staticWebsite: {
      enabled: false
    }
    containerDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
    cors: {
      corsRules: []
    }
    deleteRetentionPolicy: {
      allowPermanentDelete: false
      enabled: true
      days: 7
    }
  }
}

resource storageAccounts_storagebackups001_name_default 'Microsoft.Storage/storageAccounts/fileServices@2026-04-01' = {
  parent: storageAccounts_storagebackups001_name_resource
  name: 'default'
  sku: {
    name: 'StandardV2_GRS'
    tier: 'Standard'
  }
  properties: {
    protocolSettings: {
      smb: {
        encryptionInTransit: {
          required: true
        }
        multichannel: {
          enabled: false
        }
      }
    }
    cors: {
      corsRules: []
    }
    shareDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
  }
}

resource Microsoft_Storage_storageAccounts_fileServices_storageAccounts_storageshare001_name_default 'Microsoft.Storage/storageAccounts/fileServices@2026-04-01' = {
  parent: storageAccounts_storageshare001_name_resource
  name: 'default'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    protocolSettings: {
      smb: {
        encryptionInTransit: {
          required: true
        }
      }
    }
    cors: {
      corsRules: []
    }
    shareDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
  }
}

resource storageAccounts_storagebackups001_name_storageAccounts_storagebackups001_name_52c9c016_36b9_4893_85e8_eebd0a8e7c76 'Microsoft.Storage/storageAccounts/privateEndpointConnections@2026-04-01' = {
  parent: storageAccounts_storagebackups001_name_resource
  name: '${storageAccounts_storagebackups001_name}.52c9c016-36b9-4893-85e8-eebd0a8e7c76'
  properties: {
    privateEndpoint: {}
    privateLinkServiceConnectionState: {
      status: 'Approved'
      description: 'Auto-Approved'
      actionRequired: 'None'
    }
  }
}

resource Microsoft_Storage_storageAccounts_queueServices_storageAccounts_storageshare001_name_default 'Microsoft.Storage/storageAccounts/queueServices@2026-04-01' = {
  parent: storageAccounts_storageshare001_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource Microsoft_Storage_storageAccounts_tableServices_storageAccounts_storageshare001_name_default 'Microsoft.Storage/storageAccounts/tableServices@2026-04-01' = {
  parent: storageAccounts_storageshare001_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource privateDnsZones_privatelink_file_core_windows_net_name_ocr5zys2tqsbk 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' = {
  parent: privateDnsZones_privatelink_file_core_windows_net_name_resource
  name: 'ocr5zys2tqsbk'
  location: 'global'
  properties: {
    registrationEnabled: false
    resolutionPolicy: 'Default'
    virtualNetwork: {
      id: virtualNetworks_VNat_Private_name_resource.id
    }
  }
}

resource privateEndpoints_P_Storage_name_resource 'Microsoft.Network/privateEndpoints@2025-07-01' = {
  name: privateEndpoints_P_Storage_name
  location: 'eastus'
  properties: {
    privateLinkServiceConnections: [
      {
        name: privateEndpoints_P_Storage_name
        id: '${privateEndpoints_P_Storage_name_resource.id}/privateLinkServiceConnections/${privateEndpoints_P_Storage_name}'
        properties: {
          privateLinkServiceId: storageAccounts_storagebackups001_name_resource.id
          groupIds: [
            'file'
          ]
          privateLinkServiceConnectionState: {
            status: 'Approved'
            description: 'Auto-Approved'
            actionsRequired: 'None'
          }
        }
      }
    ]
    manualPrivateLinkServiceConnections: []
    customNetworkInterfaceName: '${privateEndpoints_P_Storage_name}-nic'
    subnet: {
      id: virtualNetworks_VNat_Private_name_Subnet_Private.id
    }
    ipConfigurations: []
    customDnsConfigs: []
    ipVersionType: 'IPv4'
  }
}

resource privateEndpoints_P_Storage_name_default 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2025-07-01' = {
  name: '${privateEndpoints_P_Storage_name}/default'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'privatelink-file-core-windows-net'
        properties: {
          privateDnsZoneId: privateDnsZones_privatelink_file_core_windows_net_name_resource.id
        }
      }
    ]
  }
  dependsOn: [
    privateEndpoints_P_Storage_name_resource
  ]
}
