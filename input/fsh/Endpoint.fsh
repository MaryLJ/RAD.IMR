Profile:        IMRStudyEndpoint
Parent:         Endpoint
Id:             imr-study-endpoint
Title:          "IMR Study Endpoint"
Description:    "IHE Interactive Multimedia Report (IMR) profile on Endpoint for Study"

* connectionType from IMRStudyEndpointConnectionTypeVS (required)

* payloadType 1..1

* payloadType ^slicing.discriminator.type = #pattern
* payloadType ^slicing.discriminator.path = "coding"
* payloadType ^slicing.rules = #open
* payloadType ^slicing.description = "Slice based on the payloadType.coding"
* payloadType ^slicing.ordered = false

* payloadType contains study 1..1 MS
* payloadType[study].coding from IMRStudyEndpointPayloadTypeVS (extensible)


ValueSet: IMRStudyEndpointConnectionTypeVS
Id: imr-study-endpoint-connectiontype-vs
Title: "IMR Study Endpoint ConnectionType Value Set"
Description: "Codes representing the applicable endpoint connectionType to retrieve a study."
* FHIREndpoint#ihe-iid "IHE IDD"
* FHIREndpoint#dicom-wado-rs "DICOM WADO-RS"


ValueSet: IMRStudyEndpointPayloadTypeVS
Id: imr-study-endpoint-payloadtype-vs
Title: "IMR Study Endpoint PayloadType Value Set"
Description: "Codes representing the applicable endpoint payloadType to retrieve a study."
* DICOM#113014 "Study"
* DICOM#113015 "Series"