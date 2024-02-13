//
//  DADiskExtension.swift
//  EcoEnergy
//
//  Created by Marcelo De Araújo on 13/02/2024.
//

import DiskArbitration
#if os(macOS)
@available(macOS 12, *)
extension DADisk {

    var wholeDisk: DADisk? { DADiskCopyWholeDisk(self) }
    var description: [String: AnyObject]? { DADiskCopyDescription(self) as? [String: AnyObject] }
    var mediaSize: Int? { description?["DAMediaSize"] as? Int }
    var deviceModel: String? { description?["DADeviceModel"] as? String }
    var isEjectable: Bool? { description?["DAMediaEjectable"] as? Bool }
    var isRemovable: Bool? { description?["DAMediaRemovable"] as? Bool }
    var mediaName: String? { description?["DAMediaName"] as? String }
    var volumeName: String? { description?["DAVolumeName"] as? String }
    var mediaBSDName: String? { description?["DAMediaBSDName"] as? String }
    var deviceProtocol: String? { description?["DADeviceProtocol"] as? String }
    var volumeType: String? { description?["DAVolumeType"] as? String }
    var volumeKind: String? { description?["DAVolumeKind"] as? String }
    var busName: String? { description?["DABusName"] as? String }
    var busPath: String? { description?["DABusPath"] as? String }
    var deviceVendor: String? { description?["DADeviceVendor"] as? String }
    var isVolumeNetwork: Bool? { description?["DAVolumeNetwork"] as? Bool }


    var volumeUUID: String? {
        guard let description = description else { return nil }
        guard let value = description["DAVolumeUUID"] else { return nil }
        let cfUUID = value as! CFUUID
        return CFUUIDCreateString(nil, cfUUID) as String?
    }

    var mediaUUID: String? {
        guard let description = description else { return nil }
        guard let value = description["DAMediaUUID"] else { return nil }
        let cfUUID = value as! CFUUID
        return CFUUIDCreateString(nil, cfUUID) as String?
    }
}
#endif
