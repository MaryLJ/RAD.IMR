### 2:4.Y1.1 Scope

This transaction is used to store multimedia reports.

### 2:4.Y1.2 Actors Roles

The roles in this transaction are defined in the following table and may be played by the actors shown here:

**Table 2:4.Y1.2-1: Actor Roles**

| Role      | Description                                   | Actor(s)          |
|-----------|-----------------------------------------------|-------------------|
| Sender    | Store Multimedia Reports | Report Creator    |
| Receiver  | Receive Multimedia Reports | Report Repository <br> Report Reader <br> Rendered Report Reader |
{: .grid}

Transaction text specifies behavior for each role. The behavior of specific actors may also be specified when it goes beyond that of the general role.

### 2:4.Y1.3 Referenced Standards

**FHIR-R4**: [HL7 FHIR Release 4.0](http://www.hl7.org/FHIR/R4)

**HTML 5**: [HTML Living Standard](https://html.spec.whatwg.org/multipage/)

**PDF/A**: [ISO 19005-1:2005](https://www.iso.org/standard/38920.html)

### 2:4.Y1.4 Messages

<div>
{%include RAD-Y1-seq.svg%}
</div>

<div style="clear: left"/>

**Figure 2:4.Y1.4-1: Interaction Diagram**

#### 2:4.Y1.4.1 Store Multimedia Report Bundle Request Message
The Sender sends a multimedia report bundle to the Receiver.  The Sender shall support sending such messages to more than one Receiver.

The Receiver shall support handling such messages from more than one Sender. 

##### 2:4.Y1.4.1.1 Trigger Events

The Sender determines that a multimedia report is ready to be sent. e.g. a radiologist completed a dictation on a study and signed off the report. This trigger is associated with an intention that the Receiver stores the multimedia report contents and makes it available for subsequent query and retrieve requests.

##### 2:4.Y1.4.1.2 Message Semantics

This message is an HTTP POST request. The Sender is the User Agent. The Receiver is the Origin Server.

The Sender shall initiate a FHIR “transaction” using a “create” action by sending an HTTP POST request method composed of an IMR Bundle Resource containing the following:
- one DiagnosticReport Resource
- one or more ServiceRequest Resources
- one Patient Resource
- one or more Organization Resources
- one or more Practitioner Resources
- one or more Observation Resources
- one or more ImagingStudy Resources

The media type of the HTTP body shall be either `application/fhir+json` or `application/fhir+xml`.

See [http://hl7.org/fhir/http.html#transaction](http://hl7.org/fhir/http.html#transaction) for complete requirements of a FHIR transaction. See [http://hl7.org/fhir/bundle-transaction.html](http://hl7.org/fhir/bundle-transaction.html) for an example of a transaction bundle.

The Sender shall send the message to the following URL:
```
[base]/Bundle
```
This URL is configurable by the Responder and is subject to the following constraints: 

The `[base]` is the [Service Base URL](https://www.hl7.org/fhir/http.html#root), which is the address where all of the resources defined by this interface are found.

The following subsections contain additional constraints on the contents of the IMR Bundle.

###### 2:4.Y1.4.1.2.1 IMR Bundle Resource 

For complete information on constructing a FHIR Bundle Resource, see [http://hl7.org/fhir/bundle.html](http://hl7.org/fhir/bundle.html)

The FHIR Bundle.meta.profile shall have the following value: `http://profiles.ihe.net/RAD/IMR/StructureDefinition/imr-bundle`

The [IMR Bundle](StructureDefinition-imr-store-multimedia-report-bundle.html): 
  - shall be a [Transaction Bundle](http://hl7.org/fhir/http.html#transaction)
  - shall create one [IMR DiagnosticReport](StructureDefinition-imr-diagnosticreport.html)
  - may create/update/read one or more [IMR ServiceRequest](StructureDefinition-imr-servicerequest.html)
  - may create/update/read one [Patient](http://hl7.org/fhir/patient.html)
  - may create/read one or more [Organization](http://hl7.org/fhir/organization.html)
  - may create/read one or more [Practitioner](http://hl7.org/fhir/practitioner.html)
  - may create/read one or more [IMR Observation](StructureDefinition-imr-observation.html)
  - may create/read one or more [IMR ImagingStudy](StructureDefinition-imr-imagingstudy.html)

The Sender may set meta.profile of each resource to be the corresponding IMR profile. This enables a Receiver to validate the received resource against the IMR resource profile specification.

> Note that a Sender may choose not to set meta.profile to a specific profile, or may set it to multiple profiles.

The Sender shall create corresponding properly identifiable resources unless the proper record keys or absolute identification information is not available. Identifiable resources are preferred because each resource in the bundle is valuable as a standalone resource outside the context of the IMR DiagnosticReport Resource (e.g. independently searchable, and the same resource can be referenced multiple times).

When resources are `contained`, they shall be contained using the FHIR contained method (see [http://hl7.org/fhir/references.html#contained](http://hl7.org/fhir/references.html#contained) ).

###### 2:4.Y1.4.1.2.2 IMR DiagnosticReport Resource 

The Sender shall construct the IMR DiagnosticReport Resource according to the IMR DiagnosticReport [StructureDefinition](StructureDefinition-imr-diagnosticreport.html)

[Section 2:4.Y1.4.1.2.2.1](#24y141221-mapping-of-attributes-in-a-diagnostic-report) contains mapping requirements.

[Section 2:4.Y1.4.1.2.2.2](#24y141222-rendered-report-in-imr-diagnosticreport-resource) contains requirements for including a rendered report in an IMR DiagnosticReport Resource.

A complete example of an IMR DiagnosticReport Resource is available in [IMR DiagnosticReport Example](DiagnosticReport-ex-DiagnosticReport.json.html).

###### 2:4.Y1.4.1.2.2.1 Mapping of Attributes in a Diagnostic Report

There is a common set of attributes included in radiology diagnostic reports. Table 2:4.Y1.4.1.2.2.1-1 specifies how the Sender shall map these attributes to the IMR DiagnosticReport Resource and other referenced resources.  Refer to the StructureDefinition for these resources on the [Artifacts](artifacts.html) page.

**Table 2:4.Y1.4.1.2.2.1-1: Mapping of Attributes in DiagnosticReport**

| Report Attribute | FHIR Resource Mapping | Additional Constraint | Note |
|------------------|-----------------------|-----------------------|------|
| Organization     | DiagnosticReport.performer | See [IMR DiagnosticReport](StructureDefinition-imr-diagnosticreport.html) for details | The organization which is responsible for the diagnostic report. <br><br> See Note 1 |
| Results Interpreter | DiagnosticReport.resultsInterpreter | Can be either Practitioner or PractitionerRole <br><br> See [IMR DiagnosticReport](StructureDefinition-imr-diagnosticreport.html) for details | | The primary result interpreter(s) <br><br> See Note 1 |
| Patient Name     | DiagnosticReport.subject.name -> Patient.name | See [IMR DiagnosticReport](StructureDefinition-imr-diagnosticreport.html) for details | See Note 1 |
| Patient ID       | DiagnosticReport.subject.identifier -> Patient.identifier | See [IMR DiagnosticReport](StructureDefinition-imr-diagnosticreport.html) for details | See Note 1 |
| Accession Number | DiagnosticReport.basedOn.identifier -> IMRServiceRequest.identifier | See [IMR DiagnosticReport](StructureDefinition-imr-diagnosticreport.html) and [IMR ServiceRequest](StructureDefinition-imr-servicerequest.html) for details | Identified by the identifier.type |
| Study Date       | DiagnosticReport.imagingStudy.started -> IMRImagingStudy.started | See [IMR ImagingStudy](StructureDefinition-imr-imagingstudy.html) for details | |
| Study Type       | DiagnosticReport.imagingStudy.procedureCode -> IMRImagingStudy.procedureCode | See [IMR ImagingStudy](StructureDefinition-imr-imagingstudy.html) for details | |
| Report Status    | DiagnosticReport.status | partial, preliminary, final, amended, corrected, appended, cancelled <br><br> See [IMR DiagnosticReport](StructureDefinition-imr-diagnosticreport.html) for details | A subset from what is defined in FHIR |
| Report Sign-off Time | DiagnosticReport.issued | See [IMR DiagnosticReport](StructureDefinition-imr-diagnosticreport.html) for details | |
| Examination      | DiagnosticReport.code | See [IMR DiagnosticReport](StructureDefinition-imr-diagnosticreport.html) for details | Code for the type of diagnostic report, may be the same as the study procedure code |
| Indication       | DiagnosticReport.extension[indication] | See [IMR DiagnosticReport](StructureDefinition-imr-diagnosticreport.html) for details | Each value can be either a string or a CodeableConcept |
| Technique        | DiagnosticReport.result.method -> IMRObservation.method | Technique details is set in the same observation  resource that captures the finding. i.e. IMRObservation.code = LOINC#59776-5 "Procedure Findings" <br><br> See [IMR DiagnosticReport](StructureDefinition-imr-diagnosticreport.html) and [IMR Observation](StructureDefinition-imr-observation.html) for details | |
| Comparison       | DiagnosticReport.extension[comparisonStudy] | Can be either an IMRImagingStudy or IMRDiagnosticReport <br><br> See [IMR DiagnosticReport](StructureDefinition-imr-diagnosticreport.html) for details | |
| Report Section   | DiagnosticReport.result.valueString -> IMRObservation.valueString | Identified by IMRObservation.code. See [IMR DiagnosticReport](StructureDefinition-imr-diagnosticreport.html) and [IMR Observation](StructureDefinition-imr-observation.html) for details | The code is used to identify what *section* the observation belongs to. For example, LOINC code __59776-5__ represents a procedure finding and LOINC code __19005-8__ represents a narrative impression. <br><br> Highly recommended to encode a single finding or impression per IMR Observation, but permitted to encode all findings as a single string and all impressions as a single string to bridge existing applications. <br><br> Also See Note 2 |
{: .grid}

> Note 1: There is no IMR-defined FHIR resource profile for the resource. An implementation may use other FHIR resource profiles applicable for their deployment.

> Note 2: In common cases, there is no direct association between findings and impressions except that they are associated with the same DiagnosticReport Resource. 

In addition to the common set above, there are also a number of useful optional attributes that the Sender may included.

**Table 2:4.Y1.4.1.2.1-2: Useful Optional Attributes in Radiology Diagnostic Report**

| Report Attribute | FHIR Resource Mapping | Additional Constraint | Note |
|------------------|-----------------------|-----------------------|------|
| Referring Physician | DiagnosticReport.imagingStudy -> IMRImagingStudy.referrer | |
| Reason For Study | DiagnosticReport.imagingStudy -> IMRImagingStudy.reasonCode | |
| Study Description | DiagnosticReport.imagingStudy -> IMRImagingStudy.description | |
| Body Part | DiagnosticReport.result -> IMRObservation.bodySite | Note 3 |
| Relationship between findings and impressions | DiagnosticReport.result -> IMRObservation.hasMember | | Specify related observations, e.g. linking impression to finding, or finding to another finding |
{: .grid}

> Note 3: See [HIMSS-SIIM Whitepaper: The Importance of Body Part Labeling to Enable Enterprise Imaging](https://link.springer.com/article/10.1007/s10278-020-00415-0) for the importance of body part labelling.

###### 2:4.Y1.4.1.2.2.2 Rendered Report in IMR DiagnosticReport Resource

The Sender shall include in DiagnosticReport.presentedForm at least one rendered report in HTML format. DiagnosticReport.presentedForm.contentType shall have the value "text/html".   

The Sender may include other renditions of the same report (e.g. PDF).

For all rendered reports, the Sender shall set the DiagnosticReport.presentedForm.contentType with a value corresponding to the rendered report format.

The Sender shall encode the rendered report that is referenced by DiagnosticReport.presentedForm in one of the following ways:
- as a base64Binary in DiagnosticReport.presentedForm.data
- as a base64Binary in a [Binary Resource](https://www.hl7.org/fhir/binary.html), and this Binary Resource is referenced in DiagnosticReport.presentedForm.url.
  - The Binary Resource shall be in the Bundle. See FHIR Resolving references in Bundles at [http://hl7.org/fhir/bundle.html#references](http://hl7.org/fhir/bundle.html#references). 
- host the rendered report somewhere and provide the url in DiagnosticReport.presentedForm.url

The Sender shall populate accurate values for hash and size for the rendered report content in DiagnosticReport.presentedForm.hash and DiagnosticReport.presentedForm.size: 
* Where the presentedForm is a Binary Resource instance, the .hash and .size shall represent the raw artifact that has been base64encoded in the Binary.data element.  
* Where the presentedForm is hosted elsewhere, not as a Binary Resource, the .hash and the .size shall represent the rendered report content that would be retrieved using the mime-type specified in DiagnosticReport.presentedForm.contentType. 

###### 2:4.Y1.4.1.2.2.2.1 Image References in Rendered Report

This section contains requirements for the Sender that needs to include image references in the rendered report in HTML format in DiagnosticReport.presentedForm 

For IMR Observations that have image references using Observation.derivedFrom attribute (see [Section 2:4.Y1.4.1.2.3.1](#24y141231-image-references-in-an-imr-observation-resource), the Sender shall add a hyperlink using the HTML anchor element (i.e. `<a>`), with the display text for the hyperlink being the corresponding value[x] in a clinically relevant textual representation. The value for href for this hyperlink shall be constructed based on the endpoint(s) defined in the referenced [IMR ImagingStudy](StructureDefinition-imr-imagingstudy.html) Resource.

For inline image references in Observation.valueString, the Sender shall substitute each `<IMRRef>`...`</IMRRef>` markup with an HTML anchor element. The href attribute shall be set to the concatenation of the ImagingStudy.endpoint.address with the valueString from the matching Observation.component.id entry. The resulting URL shall be a valid URL according to the contentType.

The Sender shall construct the resulting URLs such that the contents returned upon invocation are ready to be presented, rather than contents that would require download and additional tools in order to present. For example, using a WADO-RS URL with a rendered image is appropriate, whereas a plain WADO-RS URL to retrieve a DICOM object is not.

> In other words, the Sender shall not presume that the Receiver can download and render the linked content.

###### 2:4.Y1.4.1.2.2.2.2 Rendered Report in PDF Format

A Sender that supports the **PDF Report Option**, if configured, shall also include a semantically equivalent diagnostic report in PDF format in the DiagnosticReport.presentedForm attribute. The presentedForm.contentType shall have the value "application/pdf". The Sender shall include in the PDF report all text and linked contents as in the HTML report. The Sender may preserve the linked contents as hyperlinks, or substitute the linked contents with the actual rendered contents and embedded them in the PDF file.

###### 2:4.Y1.4.1.2.3 IMR Observation Resource

The Sender shall encode all clinical finding(s), impressions(s) or other observation(s) using IMR Observation Resources.

> See [Section 1:XX.4.1.1](volume-1.html#1xx411-structure-in-radiology-reporting) "Structure in Radiology Reporting" for discussions regarding different *structures* applicable to radiology reporting.

The Sender shall set the `code` attribute according to the [IMR Observation](StructureDefinition-imr-observation.html) resource profile indicating whether the IMR Observation Resource represents finding(s), impression(s), or some other type of observations.

For clinical findings, the Sender shall either: 
- encode each finding as a separate [IMR Observation] (StructureDefinition-imr-observation.html) Resource, **or** 
- include all findings in a single IMR Observation Resource as narrative content in Observation.valueString. See [IMR Observation Examples](StructureDefinition-imr-observation-examples.html) for an example that encodes multiple findings in paragraph form in a single IMR Observation Resource.

For clinical impressions, the Sender shall either:
- include each impression as a separate [IMR Observation](StructureDefinition-imr-observation.html) Resource, **or**
- include all impressions a single IMR Observation Resource as a narrative content in Observation.valueString. See [IMR Observation Examples](StructureDefinition-imr-observation-examples.html) for examples that encode different impression as different IMR Observation Resources.

The Sender shall encode narrative content in findings or impressions using Observation.valueString.

The Sender may encode code-able content in findings or impressions using the appropriate data type available in Observation.value[x].

###### 2:4.Y1.4.1.2.3.1 Image References in an IMR Observation Resource

The Sender shall encode the study in which this observation is derived from, if available, in Observation.derivedFrom using an [IMR ImagingStudy](StructureDefinition-imr-imagingstudy.html) Resource. This attribute shall include the study and series references. IMR ImagingStudy may include image references.

For narrative content, the Sender may directly embed one or more image references inline the text.  TO DO:  Does this sentence belong under IMR DiagnosticReport ?? 

The Sender shall specify each inline image reference using the `<IMRRef>` XML element and the corresponding `</IMRRef>` end element. This `<IMRRef>` element shall have the attributes as defined in Table 2:4.Y1.4.1.3.1-1.

> Note: IMR currently requires image references only. References to other DICOM objects such as segmentation objects, parametric maps or other non-DICOM objects are out of scope of IMR.

**Table 2:4.Y1.4.1.2.3.1-1: Attributes for the `<IMRRef>` element**

| Attribute | Optionality | Description |
|-----------|-------------|-------------|
| type      | R | Type of multimedia content. Value shall be 'image' |
| id        | R | Maps to component.id in the same Observation Resource |
{: .grid}

This `<IMRRef>` represents a *placeholder* for the image reference details. The display text is the text enclosed by the `<IMRRef>` element.

The Sender shall encode the corresponding image reference details in the same Observation Resource using Observation.component as follows:
- Observation.component.id shall match the `id` attribute in the `<IMRRef>` tag
- Observation.component.valueString shall have the value for the series instance UID and SOP Instance UID in the format `/series/{seriesUID}/instance/{sopInstanceUID}`,
- Observation.component.code shall have the coded value (55113-5, "http://loinc.org", "Key Images")

Example 1: The image references are specified inline with the corresponding measurements
```
The imaged portion of a thyroid gland is unremarkable. Prominent or mildly enlarged mediastinal and bilateral hilar lymph nodes measure up to <IMRRef type="image" id=1>1.2 x 0.8 cm in the right paratracheal station</IMRRef>, <IMRRef type="image" id=2>2.3 x 1.4 cm in the subcarinal station</IMRRef>, and <IMRRef type="image" id=3>1.4 x 0.9 cm in the right hilar stations</IMRRef>. No significant axillary lymphadenopathy is detected.
```

In Example 1, the display text for the hyperlink is the corresponding measurement details.

Example 2: The image references are specified adjacent to the corresponding measurements
```
The imaged portion of a thyroid gland is unremarkable. Prominent or mildly enlarged mediastinal and bilateral hilar lymph nodes measure up to 1.2 x 0.8 cm in the right paratracheal station<IMRRef type="image" id=1>image</IMRRef>, 2.3 x 1.4 cm in the subcarinal station<IMRRef type="image" id=2>image</IMRRef>, and 1.4 x 0.9 cm in the right hilar stations<IMRRef type="image" id=3>image</IMRRef>. No significant axillary lymphadenopathy is detected.
```

In Example 2, the display text for the hyperlink is the simple text **image** adjacent to the corresponding measurement details.

> Note: The current design of Observation only supports a single image reference in the same study context as the Observation (i.e. Observation.derivedFrom) for each inline reference using the `<IMRRef>` tag. FHIR is working on a new ImagingSelection Resource which supports referencing multiple images as well as image regions in any study. It is the intention of IMR that when ImagingSelection becomes available, IMR will be updated to support it as an extension in Observation.component.

> Note: The current design of a FHIR DiagnosticReport does not define how the different attributes should be presented in what order, except for the presentedForm. FHIR is working on integrating DiagnosticReport with Composition, which enables an explicit control of sections. It is the intention of IMR that when Composition is integrated with DiagnosticReport, IMR will be updated to support it.

Informative examples are available at [IMR Observation Examples](StructureDefinition-imr-observation-examples.html) to demonstrate the possible encoding of different kinds of observations.

###### 2:4.Y1.4.1.2.4 Patient, Organization, Practitioner, PractitionerRole Rescources

The Patient, Organization, Practitioner or PractitionerRole Resources are required resources. However, IMR does not specify any FHIR resource profiles on these resources. These resources are not radiology or imaging specific. Real world deployment may specify constraints on these resources.

##### 2:4.Y1.4.1.3 Expected Actions

The Receiver shall accept both media types `application/fhir+json` and `application/fhir+xml`.

On receipt of the request message, the Receiver shall validate the resources and respond with one of the HTTP codes defined in the response [Message Semantics](#24y1412-message-semantics). 

The Receiver shall process the transaction bundle atomically as specified in [http://hl7.org/fhir/http.html#transaction](http://hl7.org/fhir/http.html#transaction). 

> Note: Local policy might reject bundles containing resources such as Patient, Organization, Practitioner, etc. referenced that are unknown to the Receiver. Local policy may allow a Receiver to support "conditional create" semantics (currently in trial use as defined in [FHIR RESTful API](https://www.hl7.org/fhir/http.html#create). Therefore the actual behavior is at the discretion of the Receiver actor policy.

The Receiver shall retrieve any Resources referenced by absolute URLs in the FHIR Bundle Resource.

The Receiver shall validate the bundle first against the FHIR specification. Guidance on what FHIR considers a valid Resource can be found at [http://hl7.org/fhir/validation.html](http://hl7.org/fhir/validation.html). 

Once the bundle is validated, the Receiver shall store the report and all associated resources.

A Receiver is permitted to coerce resource values that violate IMR requirements.

The Receiver shall be able to retrieve the hosted rendered report(s) in DiagnosticReport.presentedForm.url and embed them in the corresponding DiagnosticReport.presentedForm.data.

The Receiver may extract the embedded rendered report(s) in DiagnosticReport.presentedForm.data, store them and substitute the corresponding DiagnosticReport.presentedForm with a URL (i.e. DiagnosticReport.presentedForm.url) instead.

The Receiver shall maintain the integrity of the report if the report access method is modified (i.e. from embedded to hosted, or vice versa).

If the Receiver encounters any errors or if any validation fails, the Receiver shall return an appropriate error.

#### 2:4.Y1.4.2 Store Multimedia Report Bundle Response Message

The Receiver sends a response message describing the message outcome to the Sender.

##### 2:4.Y1.4.2.1 Trigger Events

The Receiver receives a Store Multimedia Report Bundle Request message.

##### 2:4.Y1.4.2.2 Message Semantics

This message is an HTTP POST response. The Sender is the User Agent. The Receiver is the Origin Server.

The Receiver returns an HTTP Status code appropriate to the processing outcome, conforming to the transaction specification requirements in [http://hl7.org/fhir/http.html#trules](http://hl7.org/fhir/http.html#trules) to the Sender. This enables the Sender to know the outcome of processing the FHIR transaction, and the identities assigned to the resources by the Receiver.

The Receiver shall construct a Bundle, with `type` set to `transaction-response`, that contains one entry for each entry in the request, in the same order as received, with the `Bundle.entry.response.outcome` indicating the results of processing the entry warnings such as PartialFolderContentNotProcessed. The Receiver shall comply with FHIR [http://hl7.org/fhir/bundle.html#transaction-response](http://hl7.org/fhir/bundle.html#transaction-response) and [http://hl7.org/fhir/http.html#transaction-response](http://hl7.org/fhir/http.html#transaction-response).

To indicate success, the Receiver shall return an HTTP status `200`. The Receiver shall include in the HTTP response header the `location` element, and the `etag` element if the Receiver supports FHIR resource versioning.

The `Bundle.entry.response.status` shall be `201` to indicate the Resource has been created. 

The Receiver shall not send a success response until the multimedia report is completely processed and persisted as appropriate to the Receiver configuration.

An informative StructureDefinition is found at [IMR Store Multimedia Report Bundle Message](StructureDefinition-imr-store-multimedia-report-bundle.html).

##### 2:4.Y1.4.2.3 Expected Actions

If the Receiver returns an HTTP redirect response (HTTP status codes 301, 302, 303, or 307), the Sender shall follow the redirect, but may stop processing if it detects a loop. See [RFC7231 Section 6.4 Redirection 3xx](https://tools.ietf.org/html/rfc7231#section-6.4).

The Sender processes the results according to application-defined rules.	

#### 2:4.Y1.4.3 CapabilityStatement Resource

Receiver shall provide a CapabilityStatement Resource as described in [ITI TF-2: Appendix Z.3](https://profiles.ihe.net/ITI/TF/Volume2/ch-Z.html#z.3-capabilitystatement-resource) indicating which resources associated with an IMR report have been implemented. 

### 2:4.Y1.5 Security Considerations

The Sender may use external URLs in presentedForm.url. In this case, the Receiver should consider validating the URL to ensure that it is a valid URL referencing a known legitimate host to avoid phishing attack.

#### 2:4.Y1.5.1 Security Audit Considerations

This transaction is associated with a 'Patient-record-event' ATNA Trigger Event on both the Sender and the Receiver. See [ITI TF-2: 3.20.4.1.1.1](https://profiles.ihe.net/ITI/TF/Volume2/ITI-20.html#3.20.4.1.1.1).
