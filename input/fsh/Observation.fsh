Profile:        IMRObservation
Parent:         Observation
Id:             imr-observation
Title:          "IMR Observation"
Description:    "IHE Interactive Multimedia Report (IMR) profile on Observation"

* obeys IMRObservationInvariant

// Shall reference one ServiceRequest
* basedOn 1..1

* basedOn ^slicing.discriminator.type = #type
* basedOn ^slicing.discriminator.path = Observation.basedOn.resolve()
* basedOn ^slicing.rules = #open
* basedOn ^slicing.description = "Slice based on the basedOn reference type"
* basedOn ^slicing.ordered = false

* basedOn contains serviceRequest 1..1
* basedOn[serviceRequest] only Reference(IMRServiceRequest)

// Specify the category to be imaging
* category 1..*

* category ^slicing.discriminator.type = #pattern
* category ^slicing.discriminator.path = "coding"
* category ^slicing.rules = #open
* category ^slicing.description = "Slice based on the category.coding"
* category ^slicing.ordered = false

* category contains imaging 1..1 MS
* category[imaging].coding = FHIRObservation#imaging "Imaging"

// Shall reference on Patient
* subject 1..1
* subject only Reference(Patient)

* effectiveDateTime 1..1 MS

// At least one performer is an Organization
* performer 0..*

* performer ^slicing.discriminator.type = #type
* performer ^slicing.discriminator.path = Observation.performer.resolve()
* performer ^slicing.rules = #open
* performer ^slicing.description = "Slice based on the performer reference type"
* performer ^slicing.ordered = false

* performer contains practitionerOrOrganization 0..*
* performer[practitionerOrOrganization] only Reference(Practitioner or Organization)

// Must support either value[x] or interpretation
* value[x] 0..1 MS
* interpretation 0..* MS

// Maximum one study to be referenced in derivedFrom
* derivedFrom 0..* MS

* derivedFrom ^slicing.discriminator.type = #type
* derivedFrom ^slicing.discriminator.path = Observation.derivedFrom.resolve()
* derivedFrom ^slicing.rules = #open
* derivedFrom ^slicing.description = "Slice based on the derivedFrom reference type"
* derivedFrom ^slicing.ordered = false

* derivedFrom contains imagingStudy 0..1
* derivedFrom[imagingStudy] only Reference(IMRDiagnosticReportImagingStudy)

* component 0..* MS

Invariant:   IMRObservationInvariant
Description: "Either value[x] or interpretation or both SHALL be present"
Expression:  "value[x].exists() or interpretation.exists()"
Severity:    #error