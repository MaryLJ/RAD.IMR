Profile:        IMRImagingStudy
Parent:         ImagingStudy
Id:             imr-imagingstudy
Title:          "IMR ImagingStudy"
Description:    "IHE Interactive Multimedia Report (IMR) profile on ImagingStudy"

// Must have an identifier which is the study instance UID
* identifier 1..*

* identifier ^slicing.discriminator.type = #pattern
* identifier ^slicing.discriminator.path = type.coding
* identifier ^slicing.rules = #open
* identifier ^slicing.description = "Slice based on the identifier.type.coding"
* identifier ^slicing.ordered = false

* identifier contains studyUID 1..1 MS
* identifier[studyUID].type 1..1 MS
* identifier[studyUID].type.coding = DICOM#110180 "Study Instance UID"
* identifier[studyUID].value 1..1 MS

* modality 1..*

* subject only Reference(Patient)

* started 1..1 MS

// Shall reference one ServiceRequest
* basedOn 0..*

* basedOn ^slicing.discriminator.type = #type
* basedOn ^slicing.discriminator.path = resolve()
* basedOn ^slicing.rules = #open
* basedOn ^slicing.description = "Slice based on the basedOn reference type"
* basedOn ^slicing.ordered = false

* basedOn contains serviceRequest 0..*
* basedOn[serviceRequest] only Reference(IMRServiceRequest)

// Must have at least one endpoint at the study level of type IMRStudyEndpoint
* endpoint 1..*
* endpoint only Reference(IMRStudyEndpoint)

// At least one series must exist
* series 1..* MS
