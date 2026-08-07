param loadBalancers_LB_Web_name string = 'LB-Web'
param virtualNetworks_VNet_Web_name string = 'VNet-Web'
param virtualMachines_vm_web_01_name string = 'vm-web-01'
param virtualMachines_vm_web_02_name string = 'vm-web-02'
param virtualNetworks_vnet_e66b0_name string = 'vnet-e66b0'
param publicIPAddresses_pip_e66b0_name string = 'pip-e66b0'
param networkSecurityGroups_NSG_Web_name string = 'NSG-Web'
param publicIPAddresses_vm_web_01_ip_name string = 'vm-web-01-ip'
param publicIPAddresses_vm_web_02_ip_name string = 'vm-web-02-ip'
param networkSecurityGroups_nsg_e66b0_name string = 'nsg-e66b0'
param networkInterfaces_vm_web_01317_z1_name string = 'vm-web-01317_z1'
param networkInterfaces_vm_web_02662_z1_name string = 'vm-web-02662_z1'

resource networkSecurityGroups_nsg_e66b0_name_resource 'Microsoft.Network/networkSecurityGroups@2025-07-01' = {
  name: networkSecurityGroups_nsg_e66b0_name
  location: 'eastus'
  properties: {
    securityRules: []
  }
}

resource networkSecurityGroups_NSG_Web_name_resource 'Microsoft.Network/networkSecurityGroups@2025-07-01' = {
  name: networkSecurityGroups_NSG_Web_name
  location: 'eastus'
  properties: {
    securityRules: [
      {
        name: 'AllowToHTTP'
        id: networkSecurityGroups_NSG_Web_name_AllowToHTTP.id
        properties: {
          protocol: 'TCP'
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 200
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

resource publicIPAddresses_pip_e66b0_name_resource 'Microsoft.Network/publicIPAddresses@2025-07-01' = {
  name: publicIPAddresses_pip_e66b0_name
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
      domainNameLabel: 'vm1fqdn-e66b0'
      fqdn: 'vm1fqdn-e66b0.eastus.cloudapp.azure.com'
    }
    ipTags: []
  }
}

resource publicIPAddresses_vm_web_01_ip_name_resource 'Microsoft.Network/publicIPAddresses@2025-07-01' = {
  name: publicIPAddresses_vm_web_01_ip_name
  location: 'eastus'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  zones: [
    '1'
  ]
  properties: {
    ipAddress: '20.127.170.69'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
    ddosSettings: {
      protectionMode: 'VirtualNetworkInherited'
    }
  }
}

resource publicIPAddresses_vm_web_02_ip_name_resource 'Microsoft.Network/publicIPAddresses@2025-07-01' = {
  name: publicIPAddresses_vm_web_02_ip_name
  location: 'eastus'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  zones: [
    '1'
  ]
  properties: {
    ipAddress: '52.186.180.82'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
    ddosSettings: {
      protectionMode: 'VirtualNetworkInherited'
    }
  }
}

resource virtualNetworks_VNet_Web_name_resource 'Microsoft.Network/virtualNetworks@2025-07-01' = {
  name: virtualNetworks_VNet_Web_name
  location: 'eastus'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.40.0.0/16'
      ]
    }
    encryption: {
      enabled: false
      enforcement: 'AllowUnencrypted'
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: [
      {
        name: 'Subnet-Web'
        id: virtualNetworks_VNet_Web_name_Subnet_Web.id
        properties: {
          addressPrefixes: [
            '10.40.1.0/24'
          ]
          delegations: []
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

resource virtualMachines_vm_web_01_name_resource 'Microsoft.Compute/virtualMachines@2025-11-01' = {
  name: virtualMachines_vm_web_01_name
  location: 'eastus'
  zones: [
    '1'
  ]
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2s_v3'
    }
    additionalCapabilities: {
      hibernationEnabled: false
    }
    storageProfile: {
      imageReference: {
        publisher: 'canonical'
        offer: 'ubuntu-24_04-lts'
        sku: 'server'
        version: 'latest'
      }
      osDisk: {
        osType: 'Linux'
        name: '${virtualMachines_vm_web_01_name}_disk1_be4a47fa0ca8477fa9672d8dddf227c7'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
          id: resourceId(
            'Microsoft.Compute/disks',
            '${virtualMachines_vm_web_01_name}_disk1_be4a47fa0ca8477fa9672d8dddf227c7'
          )
        }
        deleteOption: 'Delete'
        diskSizeGB: 30
      }
      dataDisks: []
      diskControllerType: 'SCSI'
    }
    osProfile: {
      computerName: virtualMachines_vm_web_01_name
      linuxConfiguration: {
        disablePasswordAuthentication: false
        provisionVMAgent: true
        patchSettings: {
          patchMode: 'ImageDefault'
          assessmentMode: 'ImageDefault'
        }
      }
      secrets: []
      allowExtensionOperations: true
      requireGuestProvisionSignal: true
      adminUsername: 'azure'
    }
    securityProfile: {
      uefiSettings: {
        secureBootEnabled: true
        vTpmEnabled: true
      }
      securityType: 'TrustedLaunch'
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_vm_web_01317_z1_name_resource.id
          properties: {
            deleteOption: 'Delete'
          }
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}

resource virtualMachines_vm_web_02_name_resource 'Microsoft.Compute/virtualMachines@2025-11-01' = {
  name: virtualMachines_vm_web_02_name
  location: 'eastus'
  zones: [
    '1'
  ]
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2s_v3'
    }
    additionalCapabilities: {
      hibernationEnabled: false
    }
    storageProfile: {
      imageReference: {
        publisher: 'canonical'
        offer: 'ubuntu-24_04-lts'
        sku: 'server'
        version: 'latest'
      }
      osDisk: {
        osType: 'Linux'
        name: '${virtualMachines_vm_web_02_name}_disk1_6ff17690bdd945c5b07c71beed69044b'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
          id: resourceId(
            'Microsoft.Compute/disks',
            '${virtualMachines_vm_web_02_name}_disk1_6ff17690bdd945c5b07c71beed69044b'
          )
        }
        deleteOption: 'Delete'
        diskSizeGB: 30
      }
      dataDisks: []
      diskControllerType: 'SCSI'
    }
    osProfile: {
      computerName: virtualMachines_vm_web_02_name
      linuxConfiguration: {
        disablePasswordAuthentication: false
        provisionVMAgent: true
        patchSettings: {
          patchMode: 'ImageDefault'
          assessmentMode: 'ImageDefault'
        }
      }
      secrets: []
      allowExtensionOperations: true
      requireGuestProvisionSignal: true
      adminUsername: 'azure'
    }
    securityProfile: {
      uefiSettings: {
        secureBootEnabled: true
        vTpmEnabled: true
      }
      securityType: 'TrustedLaunch'
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_vm_web_02662_z1_name_resource.id
          properties: {
            deleteOption: 'Delete'
          }
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}

resource loadBalancers_LB_Web_name_resource 'Microsoft.Network/loadBalancers@2025-07-01' = {
  name: loadBalancers_LB_Web_name
  location: 'eastus'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    frontendIPConfigurations: [
      {
        name: 'F-${loadBalancers_LB_Web_name}'
        id: '${loadBalancers_LB_Web_name_resource.id}/frontendIPConfigurations/F-${loadBalancers_LB_Web_name}'
        properties: {
          privateIPAddress: '10.40.1.6'
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: virtualNetworks_VNet_Web_name_Subnet_Web.id
          }
          privateIPAddressVersion: 'IPv4'
        }
        zones: [
          '2'
          '3'
          '1'
        ]
      }
    ]
    backendAddressPools: [
      {
        name: 'B-Pool'
        id: '${loadBalancers_LB_Web_name_resource.id}/backendAddressPools/B-Pool'
        properties: {
          loadBalancerBackendAddresses: [
            {
              name: '610-b5da50c0-implement-and-configure-private-dns-i_vm-web-02662_z1ipconfig1'
              properties: {}
            }
            {
              name: '610-b5da50c0-implement-and-configure-private-dns-i_vm-web-01317_z1ipconfig1'
              properties: {}
            }
          ]
        }
      }
    ]
    loadBalancingRules: [
      {
        name: 'LB-Role'
        id: '${loadBalancers_LB_Web_name_resource.id}/loadBalancingRules/LB-Role'
        properties: {
          frontendIPConfiguration: {
            id: '${loadBalancers_LB_Web_name_resource.id}/frontendIPConfigurations/F-${loadBalancers_LB_Web_name}'
          }
          frontendPort: 80
          backendPort: 80
          enableFloatingIP: false
          idleTimeoutInMinutes: 4
          protocol: 'Tcp'
          enableTcpReset: false
          loadDistribution: 'Default'
          disableOutboundSnat: true
          enableConnectionTracking: false
          backendAddressPool: {
            id: '${loadBalancers_LB_Web_name_resource.id}/backendAddressPools/B-Pool'
          }
          backendAddressPools: [
            {
              id: '${loadBalancers_LB_Web_name_resource.id}/backendAddressPools/B-Pool'
            }
          ]
          probe: {
            id: '${loadBalancers_LB_Web_name_resource.id}/probes/H-Probe'
          }
        }
      }
    ]
    probes: [
      {
        name: 'H-Probe'
        id: '${loadBalancers_LB_Web_name_resource.id}/probes/H-Probe'
        properties: {
          protocol: 'Tcp'
          port: 80
          intervalInSeconds: 5
          numberOfProbes: 1
          probeThreshold: 1
          noHealthyBackendsBehavior: 'AllProbedDown'
        }
      }
    ]
    inboundNatRules: []
    outboundRules: []
    inboundNatPools: []
  }
}

resource networkSecurityGroups_NSG_Web_name_AllowToHTTP 'Microsoft.Network/networkSecurityGroups/securityRules@2025-07-01' = {
  name: '${networkSecurityGroups_NSG_Web_name}/AllowToHTTP'
  properties: {
    protocol: 'TCP'
    sourcePortRange: '*'
    destinationPortRange: '80'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 200
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
  dependsOn: [
    networkSecurityGroups_NSG_Web_name_resource
  ]
}

resource virtualNetworks_vnet_e66b0_name_resource 'Microsoft.Network/virtualNetworks@2025-07-01' = {
  name: virtualNetworks_vnet_e66b0_name
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
        id: virtualNetworks_vnet_e66b0_name_user_subnet.id
        properties: {
          addressPrefix: '10.0.0.0/24'
          networkSecurityGroup: {
            id: networkSecurityGroups_nsg_e66b0_name_resource.id
          }
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        name: 'server-subnet'
        id: virtualNetworks_vnet_e66b0_name_server_subnet.id
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

resource virtualNetworks_vnet_e66b0_name_server_subnet 'Microsoft.Network/virtualNetworks/subnets@2025-07-01' = {
  name: '${virtualNetworks_vnet_e66b0_name}/server-subnet'
  properties: {
    addressPrefix: '10.0.1.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_vnet_e66b0_name_resource
  ]
}

resource virtualNetworks_VNet_Web_name_Subnet_Web 'Microsoft.Network/virtualNetworks/subnets@2025-07-01' = {
  name: '${virtualNetworks_VNet_Web_name}/Subnet-Web'
  properties: {
    addressPrefixes: [
      '10.40.1.0/24'
    ]
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    defaultOutboundAccess: false
  }
  dependsOn: [
    virtualNetworks_VNet_Web_name_resource
  ]
}

resource virtualNetworks_vnet_e66b0_name_user_subnet 'Microsoft.Network/virtualNetworks/subnets@2025-07-01' = {
  name: '${virtualNetworks_vnet_e66b0_name}/user-subnet'
  properties: {
    addressPrefix: '10.0.0.0/24'
    networkSecurityGroup: {
      id: networkSecurityGroups_nsg_e66b0_name_resource.id
    }
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_vnet_e66b0_name_resource
  ]
}

resource networkInterfaces_vm_web_01317_z1_name_resource 'Microsoft.Network/networkInterfaces@2025-07-01' = {
  name: networkInterfaces_vm_web_01317_z1_name
  location: 'eastus'
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        id: '${networkInterfaces_vm_web_01317_z1_name_resource.id}/ipConfigurations/ipconfig1'
        properties: {
          privateIPAddress: '10.40.1.4'
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_vm_web_01_ip_name_resource.id
            properties: {
              deleteOption: 'Delete'
            }
          }
          subnet: {
            id: virtualNetworks_VNet_Web_name_Subnet_Web.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
          loadBalancerBackendAddressPools: [
            {
              id: '${loadBalancers_LB_Web_name_resource.id}/backendAddressPools/B-Pool'
            }
          ]
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: true
    enableIPForwarding: false
    disableTcpStateTracking: false
    networkSecurityGroup: {
      id: networkSecurityGroups_NSG_Web_name_resource.id
    }
    nicType: 'Standard'
    auxiliaryMode: 'None'
    auxiliarySku: 'None'
  }
}

resource networkInterfaces_vm_web_02662_z1_name_resource 'Microsoft.Network/networkInterfaces@2025-07-01' = {
  name: networkInterfaces_vm_web_02662_z1_name
  location: 'eastus'
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        id: '${networkInterfaces_vm_web_02662_z1_name_resource.id}/ipConfigurations/ipconfig1'
        properties: {
          privateIPAddress: '10.40.1.5'
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_vm_web_02_ip_name_resource.id
            properties: {
              deleteOption: 'Delete'
            }
          }
          subnet: {
            id: virtualNetworks_VNet_Web_name_Subnet_Web.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
          loadBalancerBackendAddressPools: [
            {
              id: '${loadBalancers_LB_Web_name_resource.id}/backendAddressPools/B-Pool'
            }
          ]
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: true
    enableIPForwarding: false
    disableTcpStateTracking: false
    networkSecurityGroup: {
      id: networkSecurityGroups_NSG_Web_name_resource.id
    }
    nicType: 'Standard'
    auxiliaryMode: 'None'
    auxiliarySku: 'None'
  }
}
