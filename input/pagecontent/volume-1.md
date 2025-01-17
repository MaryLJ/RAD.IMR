
# 1:XX Interactive Multimedia Report (IMR)
The Interactive Multimedia Report (IMR) Profile specifies how a diagnostic report with interactive multimedia content can be reliably encoded, communicated and presented.

This profile defines content for data encoding, transactions for communicating the content between systems, and behaviors for displaying the content.


## 1:X.1 IMR Actors, Transactions, and Content Modules

This section defines the actors, transactions, and/or content modules in this profile. General
definitions of actors are given in the Technical Frameworks General Introduction Appendix A.
IHE Transactions can be found in the Technical Frameworks General Introduction Appendix B.
Both appendices are located at <http://ihe.net/Technical_Frameworks/#GenIntro>.

Figure 1:XX.1-1 shows the actors directly involved in the IMR Profile and the relevant transactions
between them. If needed for context, other actors that may be indirectly involved due to their participation
in other related profiles are shown in dotted lines. Actors which have a required
grouping are shown in conjoined boxes (see [Section 1:XX.3[(#1xx3-imr-required-actor-groupings)).

<div>
    <img src="IHE_IMR_actor.drawio.png">
</div>
<br clear="all">

**Figure 1:XX.1-1: IMR Actor Diagram**

**Table 1:XX.1-1: IMR Profile - Actors and Transactions**

| Actors  | Transactions  | Initiator or Responder | Optionality     | Reference                         |
|---------|---------------|------------------------|-----------------|-----------------------------------|
| Report Creator | Store Multimedia Report \[RAD-Y1\] | Initiator | R | RAD TF-2: 4.Y1 |
| Report Repository | Store Multimedia Report \[RAD-Y1\] | Responder | R | RAD TF-2: 4.Y1 |
|                   | Find Multimedia Report  \[RAD-Y3\]| Responder | R | RAD TF-2: 4.Y3 |
|                   | Retrieve Rendered Multimedia Report \[RAD-Y4\] | Responder | R | RAD TF-2: 4.Y4 |
| Report Reader | Store Multimedia Report \[RAD-Y1\]| Responder | O (Note 1) | RAD TF-2: 4.Y1 |
|               | Display Multimedia Report \[RAD-Y2\] | N/A | R | RAD TF-2: 4.Y2 |
|               | Find Multimedia Report \[RAD-Y3\] | Initiator | O (Note 1) | RAD TF-2: 4.Y3 |
|               | Display Images \[RAD-Y5\] | N/A | R | RAD TF-2: 4.Y5 |
|               | WADO-RS Retrieve \[RAD-107\] | Initiator | O | RAD TF-2: 4.107 |
| Rendered Report Reader | Store Multimedia Report \[RAD-Y1\] | Responder | O (Note 1) | RAD TF-2: 4.107 |
|                        | Find Multimedia Report \[RAD-Y3\] | Initiator | O (Note 1) | RAD TF-2: 4.Y3 |
|                        | Retrieve Rendered Multimedia Report \[RAD-Y4\] | Initiator | R | RAD TF-2: 4.Y4 |
| Image Manager / Image Archive | Retrieve Images \[RAD-16\] | Responder | R | RAD TF-2: 4.16 |
|                               | Retrieve Presentation States \[RAD-17\] | Responder | R | RAD TF-2: 4.17 |
|                               | Retrieve Key Images \[RAD-31\] | Responder | R | RAD TF-2: 4.31 |
|                               | Retrieve Evidence Documents \[RAD-45\] | Responder | R | RAD TF-2: 4.45 |
|                               | WADO-RS Retrieve \[RAD-107\] | Responder | R | RAD TF-2: 4.107 |
| Image Display | Retrieve Images \[RAD-16\] | Initiator | O (Note 2) | RAD TF-2: 4.16 |
|               | Retrieve Presentation States \[RAD-17\] | Initiator | O | RAD TF-2: 4.17 |
|               | Retrieve Key Images \[RAD-31\] | Initiator | O | RAD TF-2: 4.31 |
|               | Retrieve Evidence Documents \[RAD-45\] | Initiator | O | RAD TF-2: 4.45 |
|               | WADO-RS Retrieve \[RAD-107\] | Initiator | O (Note 2) | RAD TF-2: 4.107 |
|               | Invoke Image Display \[RAD-106\] | Responder | O | RAD TF-2: 4.106 |
|               | Display Images \[RAD-Y5\] | N/A | R | RAD TF-2: 4.Y5 |
{: .grid}

> Note 1: The actor shall support at least one of [RAD-Y1] or [RAD-Y3].

> Note 2: The Image Display shall support at least one of WADO-RS Retrieve [RAD-107] or Retrieve Images [RAD-16].

### 1:XX.1.1 Actors Description and Actor Profile Requirements
Most requirements are documented in RAD TF-2 Transactions. This section documents any additional requirements on this profile's actors.

#### 1:XX.1.1.1 Report Creator

A Report Creator encodes diagnostic reports with multimedia content using FHIR DiagnosticReport resources. Each resulting DiagnosticReport resource also includes a default rendered report in the same DiagnosticReport resource, either as base64 encoded binary, or by reference using a URL.

A Report Creator may support creating multiple renditions of the same multimedia report for different consumers (e.g. simple consumers that do not render the detailed multimedia contents on its own, or external consumers that do not have access to studies inside the enterprise firewall).

A Report Creator stores the DiagnosticReport resources to Report Repositories, Report Readers, or Rendered Report Readers. 

> Note that in IMR, the Report Creator is the actor responsible for authoring the report. How the Report Creator receives the multimedia content in the report is out of scope for this release of IMR. In practice, a Report Creator may be grouped with an Image Display, or a Report Creator may be integrated with an Image Display via proprietary APIs or standard context sharing mechanism such as FHIRcast.

#### 1:XX.1.1.2 Report Repository

A Report Repository stores multimedia reports received from Report Creators and makes the reports available for other consumers.

A Report Repository supports query/retrieve of multimedia reports by Report Readers and Rendered Report Readers.

A Report Repository shall not modify the DiagnosticReport content, but it may modify how the embedded rendered report can be accessed, if necessary. For example, a Report Repository may adjust an internal URL to an externally accessible URL, or it may retrieve the rendered report referenced by a URL and embedded directly in the DiagnosticReport resource as base64 encoded in query responses. How a Report Repository may adjust the accessibility of the rendered report is out of scope of IMR.

#### 1:XX.1.1.3 Report Reader

A Report Reader receives multimedia reports directly from Report Creators or query/retrieves them from Report Repositories.

A Report Reader presents reports to the user, including the multimedia content embedded in the report as hyperlinks. When users click on the hyperlinks, the Report Reader presents the referenced images to the user in a way that the user can interact with the images (e.g. windowing, zooming, panning, toggle annotations, etc.).

A Report Reader shall provide baseline image viewing capabilities, i.e. [Level 2 Interactivity](#1xx416-level-of-interactivity) as discussed in Section 1:XX.4.1.6. A Report Reader may support additional advanced behavior. 

To retrieve and display referenced images in the report, Report Readers shall support at least one of the following named options:

##### 1:XX.1.1.3.1 Report Reader with Rendered Instance Retrieve Option

A Report Reader with the Rendered Instance Retrieve Option can handle retrieve and display of referenced images in multimedia reports. When triggered to view images, a Report Readers retrieves rendered images from Image Manager / Image Archive and displays the images to the user with some basic viewing capabilities.

See [Rendered Instance Retrieve Option](#1xx23-rendered-instance-retrieve-option) for details.


##### 1:XX.1.1.3.2 Report Reader with External IID Image Display Retrieve Option

A Report Reader with the External IID Image Display Retrieve Option delegates the image viewing capabilities to an external Image Display that is invoked by an integrated IID / Image Display Invoker actor. When triggered to view images, the Report Reader translates the embedded image references and endpoints in the DiagnosticReport resource into corresponding Invoke Image Display URLs.

See [External IID Image Display Retrieve Option](#1xx24-external-iid-image-display-retrieve-option) for details.

##### 1:XX.1.1.3.3 Report Reader with DICOM Instance Retrieve Option

A Report Reader with the DICOM Instance Retrieve Option integrates with an Image Display directly to provide the image viewing capabilities. When triggered to view images, the Report Reader translates the embedded image references and endpoints in the DiagnosticReport resource into corresponding commands (out of scope of IMR) and launches the integrated Image Display in context, to retrieve the images using either DICOM retrieve or WADO-RS retrieve and then display them.

See [DICOM Instance Retrieve Option](#1xx25-dicom-instance-retrieve-option) for details.

#### 1:XX.1.1.4 Rendered Report Readers

A Rendered Report Reader presents to the user the rendered report that is embedded in the DiagnosticReport resource, including the multimedia content embedded in the report as well as all hyperlinks. When the user clicks on the hyperlinks, the Rendered Report Reader launches the rendered references images to the user.

A Rendered Report Reader receives multimedia reports directly from Report Creators or query/retrieves them from Report Repositories.

A Rendered Report Reader provides [Level 1 Interactivity](#1xx416-level-of-interactivity) as discussed in Section 1:XX.4.1.6.

> Note that there are no additional image viewing capabilities required for Rendered Report Readers. In other words, the image viewing capabilities presented by the Rendered Report Readers is limited by how the Report Creator created the rendered report. For example, for image references, one Report Creator may render them using WADO-RS links which will show a static rendered image, while another Report Creator may render them using IID Invoke Image Display links which will launch a viewer to show the referenced image with additional interactivity such as scrolling, zooming, etc..

#### 1.XX.1.1.5 Image Manager / Image Archive

An Image Managers / Image Archive provides the images and related objects to the Report Readers or Image Displays.

An Image Managers / Image Archive shall support WADO-RS Retrieve [RAD-107] as well as DICOM DIMSE Services in [RAD-16], [RAD-17], [RAD-31] and [RAD-45]. This enables different types of Image Displays to retrieve objects.

An Image Managers / Image Archive shall also support returning images in the requested rendered media type as defined in DICOM PS3.18 Section 9.5 [Retrieve Rendered Instance Transaction](https://dicom.nema.org/medical/dicom/current/output/html/part18.html#sect_9.5).

#### 1.XX.1.1.6 Image Display

An Image Display retrieves images from Image Manager / Image Archives, displays the images to the user, and provides different interactive tools for user to interact with the images, based on requests from Image Display Invokers.

An Image Display that is grouped with a Report Reader shall follow the [DICOM Instance Retrieve Option](#1xx25-dicom-instance-retrieve-option).

An Image Display that is invoked by an IID Image Display Invoker grouped with a Report Reader shall implement the [External IID Image Display Retrieve Option](#1xx24-external-iid-image-display-retrieve-option).

## 1:XX.2 IMR Actor Options

Options that may be selected for each actor in this implementation guide, are listed in Table 1:XX.2-1 below. Dependencies 
between options when applicable are specified in notes.

**Table 1:XX.2-1: IMR - Actors and Options**

| Actor   | Option Name | Reference |
|---------|-------------|-----------|
| Report Creator | PDF Report | Section XX.2.1 | 
|                | HL7 Text Report | Section XX.2.2 |
| Report Repository | No options defined | -- |
| Report Reader | Rendered Instance Retrieve (Note 1) | Section XX.2.3 |
|               | External IID Image Display Retrieve (Note 1) | [Section 1:XX.2.4](#1xx24-external-iid-image-display-retrieve-option) |
|               | DICOM Instance Retrieve (Note 1) | Section XX.2.5 |
|               | Series/Study Navigation | Section XX.2.6 |
| Rendered Report Reader | PDF Report | Section XX.2.1 |
| Image Manager / Image Archive | No options defined | -- |
| Image Display | External IID Image Display Retrieve | [Section 1:XX.2.4](#1xx24-external-iid-image-display-retrieve-option) |
{: .grid}

> Note 1: The Report Reader shall support at least one of the options to retrieve images.

### 1:XX.2.1 PDF Report Option

The PDF Report Option enables actors to handle rendered reports with multimedia contents in the PDF format.

A Report Creator that supports this option shall generate a rendered multimedia report, preserving the image references as either hyperlinks or embedded static images in the rendered PDF file, and embed the rendered report in DiagnosticReport.presentedForm. A Report Creator shall preserve the readability of the report in the PDF format.

> Note that how the Report Creator renders the report into PDF is out of scope of IMR, provided that the rendered report preserves the readability of the report. For example, if there are multiple measurements in the same paragraph, each has its separate image reference(s), then if the image references are rendered as inline static images, the resulting paragraph may be broken up and become hard to read.

A Rendered Report Reader that supports this option shall support retrieving and displaying the rendered report in PDF format.

### 1:XX.2.2 HL7 Text Report Option

The HL7 Text Report Option enable actors to render a text-only version of the report.

A Report Creator that supports this option shall create a text-only rendition of the report, including the textual representation of all measurements, and may include textual representation of image references. A Report Creator shall preserve the readability of the report in the text-only format.

> For example, a textual representation of image references may look like (2,16) which means series 2 instance 16. The specific textual representation of image references is out of scope of IMR.

A Report Creator shall use this text-only report to communicate the report with existing non-IMR Report Readers, for example, using HL7 v2 ORU messages, or Send Imaging Result [RAD-128] in the IHE [Results Distribution](https://www.ihe.net/uploadedFiles/Documents/Radiology/IHE_RAD_Suppl_RD.pdf) Profile as a Report Creator.

### 1:XX.2.3 Rendered Instance Retrieve Option

The Rendered Instance Retrieve Option enables a Report Reader to retrieve rendered images from Image Manager / Image Archive using WADO-RS.  See [Use Case #2](#1xx422-use-case-2-consume-and-interact-with-multimedia-report-by-standalone-report-reader).

A Report Reader that supports this option shall use WADO-RS Retrieve [RAD-107] to retrieve rendered images from an Image Manager / Image Archive.

> Note that the retrieve rendered images functionality is available in CP-RAD-475.

The requests shall use the information in DiagnosticReport.result.derivedFrom.endpoint.address and DiagnosticReport.result.component.valueString to construct valid WADO-RS URLs that conform to the semantics as RetrieveInstance or RetrieveFrames as defined in WADO-RS Retrieve [RAD-107], retrieve the corresponding rendered images.

A Report Reader that also supports the Series/Study Navigation Option shall be able to construct WADO-RS URLs that confirm to the RetrieveSeries and RetrieveStudy semantics.

### 1:XX.2.4 External IID Image Display Retrieve Option

The External IID Image Display Retrieve Option utilizes the Invoke Image Display (IID) Profile to enable the Report Reader to display images via an external Image Display actor. See [Use Case #3] (#xx423-use-case-3-consume-and-interact-with-multimedia-report-by-report-reader-with-integrated-invoker-image-display).

A Report Reader that supports this option is grouped with an IID Image Display Invoker and shall use the Invoke Image Display [RAD-106] transaction to invoke an external Image Display.  The Report Reader shall translate the embedded image references and endpoints in the DiagnosticReport resource into corresponding Invoke Image Display [RAD-106] URLs.

An Image Display that supports this option shall support the Invoke Image Display [RAD-106] transaction as an Image Display. When the Image Display receives a [RAD-106] request, it retrieves the requested images from an Image Manager / Image Archive.

> Note that the Retrieve Display of Series Images functionality and IHE-IMR viewer type are available in CP-RAD-474.

The Invoke Image Display requests shall have the same semantics as Retrieve Display of Series Images or Retrieve Display of Study Images in Invoke Image Display [RAD-106].

> Note: [RAD-106] currently does not support invoking an Image Display at the series level nor the IHE-IMR viewer type. Retrieve Display of Series Images functionality and IHE-IMR viewer type are available in CP-RAD-474.

> Note: A Report Reader that supports this Option can also support the Series/Study Navigation Option, as the Image Display Invoker always invokes the Image Display at the series or study level.

### 1:XX.2.5 DICOM Instance Retrieve Option

The DICOM Instance Retrieve Option enables actors to retrieve and display images via an integrated Image Display actor.

A Report Reader that supports this option shall launch an Image Display to display the referenced image first. The integrated Image Display may use DICOM C-Move request or WADO-RS retrieve request to retrieve images from an Image Manager / Image Archive.

To retrieve images using DICOM DIMSE services, the integrated Image Display shall support one or more of the following transactions as an Image Display:

- Retrieve Images [RAD-16]
- Retrieve Presentation States [RAD-17]
- Retrieve Key Image Notes [RAD-31]
- Retrieve Evidence Document [RAD-45]

To retrieve images using WADO-RS, the integrated Image Display shall support WADO-RS Retrieve [RAD-107]. The requests shall have the same semantics as RetrieveInstance or RetrieveFrames, constructed based on DiagnosticReport.result.derivedFrom.endpoint.address and DiagnosticReport.result.component.valueString.

If the Report Reader also supports the Series/Study Navigation Option, then the WADO-RS request shall also support the RetrieveSeries and RetrieveStudy semantics.

The integrated Image Display may provide additional functions that the user can interact with.

### 1:XX.2.6 Series/Study Navigation Option

The Series/Study Navigation Option enables actors to scroll through images in the same series or study.

A Report Reader that supports this option shall initially display the referenced image, and shall enable the user to scroll through the other images in the same series (and optionally study) as the referenced image.

## 1:XX.3 IMR Required Actor Groupings

An actor from this profile (Column 1) shall implement all of the required transactions and/or
content modules in this profile ***in addition to all*** of the requirements for the grouped actor (Column 3).

In some cases, required groupings are defined as at least one of an enumerated set of possible actors; this is designated by merging column one into a single cell spanning multiple potential grouped actors. Notes are used to highlight this situation.

Section 1:XX.5 describes some optional groupings that may be of interest for security
considerations and Section 1:XX.6 describes some optional groupings in other related profiles.

**Table 1:XX.3-1: IMR Required Actor Groupings**

| IMR Actor | Grouping Condition | Actor(s) to be grouped with | Reference |
|-----------|--------------------|-----------------------------|-----------|
| Report Creator | Required | ITI CT / Time Client | ITI TF-1: 7.1 |
| Report Repository | -- | None | -- |
| Report Reader | With the External IID Image Display Retrieve Option | RAD IID / Image Display Invoker | RAD IID: 35.1.1.2 |
|               | With the DICOM Instance Retrieve Option | RAD IMR / Image Display | Section XX.1.1.6 |
| Rendered Report Reader | -- | None | -- |
| Image Manager / Image Archive | -- | None | -- |
| Image Display | -- | None | -- |
{: .grid}

## 1:XX.4 Interactive multimedia Report Overview

### 1:XX.4.1 Concepts

**TODO** Reference the HIMSS-SIIM IMR Technical Consideration Whitepaper when it is published

#### 1:XX.4.1.1 Structure in Radiology Reporting

In reporting, structure can significantly improve usability, both for machine consumption and human consumption. Structure can refer to several aspects within a report as follows:

##### Report Content Organization 

In a radiology report, although they are many variations of what information a report should contain depending on the procedure and specialty, there are general common sections in a report such as Indication, Methods, Findings, Impressions, etc.

The [Results Distribution](https://www.ihe.net/uploadedFiles/Documents/Radiology/IHE_RAD_Suppl_RD.pdf) profile specifies using different OBX segments for different sections while this Interactive Multimedia Report profile specifies using different FHIR DiagnosticReport.result which are referenced Observation resources for different sections.

##### Report Content Encoding

Also known as 'structured reporting' or 'synoptic reporting', encoding structure refers to the use of fully coded values in pre-coordinated form or post-coordinated form, in which the values are drawn from some value sets such as LOINC or SNOMED-CT, in order to represent the full concept.

This has been successfully used in certain discipline such as cancer screening, but it is less common in general radiology reporting practice.

##### Report Presentation

While Report Content Structure and Report Content Encoding Structure focus on imposing structure to data elements, they do not impose any requirements on how these data elements will be presented to the user. FHIR Composition resource is designed for presentation structure using elements like *section*.

> FHIR is currently working on integrating FHIR DiagnosticReport and Composition to enable better presentation structure.

##### Message Structure

In the most basic form, the clinical report is conveyed between the sender and the receiver using some kind of message format. The message format defines a structure for the overall payload, including the metadata and the actual report content. For example, HL7 v2 ORU messages or FHIR DiagnosticReport resources define such a message structure that governs where different content should be placed, such as patient, order, report content, etc.

The [Results Distribution](https://www.ihe.net/uploadedFiles/Documents/Radiology/IHE_RAD_Suppl_RD.pdf) Profile specifies using HL7 v2 ORU as the message structure while this Interactive Multimedia Report profile specifies using FHIR DiagnosticReport resource as the message structure.

The primary goal of this Interactive Multimedia Report Profile is to focus on Message Structure and Report Content Structure, introduce the ability to capture report content with some interactive links that referencing other contents such as the source images in which the measurements are derived from. It is not the intention of this profile to require fully coded content in the report.

#### 1:XX.4.1.2 Source of Multimedia Content

There are two sources of multimedia content for radiology reporting:

- User-defined
    - These are the content provided by the user. This includes, but not limited to, annotations, measurements, image references, etc.
- System-defined
    - These are the content provided by a system. For example, parametric map generated by the modality or region of interest generated by an AI model

These contents should be available to the report authoring system so that it can incorporate the details automatically.

#### 1:XX.4.1.3 Real Time Communication between Image Display / Evidence Creator and Report Creator

A key element for an IMR is the ability to include clinical findings such as measurements, ROI, etc. with interactive links to the source images. Traditionally, these annotations, markups, presentation states, and key images could be captured as DICOM objects such as GSPS, SR, or KOS. These objects are designed to capture evidence for long-term reference instead of real-time communication or composition. Most PACS will create these evidence objects at the end of a session in order to capture all the data points created by the image-centric specialist in one object, rather than create multiple evidence objects resulting in one per data point. As a result, these evidence objects in DICOM are good resources for subsequent interactive access when viewing an IMR, but not good candidates as the payload for real-time communication during a reporting session. As the image-centric specialist captures measurements, regions of interest, and other data points, ideally the PACS can provide those data points to the reporting system in real-time without introducing any unnecessary interruptions, or adding transitory content to the permanent record.

Note that this real time communication is currently out of scope of IMR.

#### 1:XX.4.1.4 Placement of Multimedia Content

At a basic level, multimedia content can be placed at the end of the report. This can be achieved with low level of communications between the PACS and the Reporting System as long as these multimedia contents (or their corresponding references) are known at some point by the Reporting System, which can then insert these contents towards the end of the report.

Although this can be useful, a more sophisticated placement of multimedia contents is the ability to insert them in context of the findings and impressions. For example, when a description such as "Prominent or mildly enlarged mediastinal and bilateral hilar lymph nodes measure up to 1.2 x 0.8 cm in the right paratracheal station" is recorded as a finding, the corresponding image reference with the matching markup if available are injected in the same context as hyperlink, such that subsequently upon viewing the report, a user can access the matching multimedia content in context while reading the report.

This sophisticated placement of multimedia contents requires a more complex interaction between the PACS and the Reporting System because both systems need to know the current context and be able to mark their respective data accordingly. This also requires a low latency communication because any pause required by the radiologist to synchronize the two systems during a reporting session will cause significant distraction to the radiologist.

#### 1:XX.4.1.5 Image References in Report 

Each image reference may references
- a single image (e.g. Frame 10)
- a range of images across multiple single-frame objects (e.g. Object 3-5) or within a multi-frame object (e.g. Frame 10-12)
- a discrete set of images (e.g. Frame 10,14,17)
- a combination of the above (e.g. Frame 10-12,14,17-20)

In most cases, the image references refer to the same study context as the study being reported on. Occasionally, the image references may refer to a comparison study that is used during reporting.

In addition to referencing a frame as a whole, sometimes the reference is specific to a region of interest in the frame. The region of interest (ROI) can be one or more points, a line or a segmented line (e.g. polyline), a geometric shape (e.g. ellipse, polygon), or a volume (e.g. ellipsoid).

#### 1:XX.4.1.6 Level of Interactivity

When interacting with multimedia reports, there are different levels of sophistication:

Level 0: No interactivity

The Report Reader can display the static content in the report, but provides no interactivity with the content for the user.

Level 1: Basic interactivity

The Report Reader can display that static content in the report, including hyperlinks to different multimedia contents in the report (e.g. measurements). The user can click on these links to access a basic view of the source image(s) in which the findings are derived from.

Level 2: Intermediate interactivity

The Report Reader can provide not only a basic view of the source image(s), but also provide other essential features such as zoom, pan, window levelling, etc. If annotations are available, then the annotations (markup, ROI, etc.) are displayed as well and able to toggle them.

Level 3: Advanced interactivity

The Report Reader can display not only the image referenced directly, but also the full series that contain the image. The Report Reader may provide other tools (e.g. measurements, more advanced image visualization, etc.) as well as support other advanced DICOM objects such as segmentation objects or parametric map objects.

#### 1:XX.4.1.7 Referenced FHIR Resource vs Contained FHIR Resource

A DiagnosticReport resource includes many references to other resources. Technically it is possible for the Report Creator to include these other resources as [contained](https://www.hl7.org/fhir/references.html#contained) resources, these contained resources are not independently accessible and they cannot be searched. Therefore in IMR, when storing a DiagnosticReport resource, all referenced resources are actual resources and are referenced accordingly.

Since a DiagnosticReport resource includes many references to other resources, such as Patient, IMR Observation, IMR ImagingStudy, etc. with FHIR [Search](http://hl7.org/fhir/search.html) capability, by default, a FHIR server returns query responses with references to other resources. The requester is expected to retrieve these referenced resources separately afterwards.

Optionally, a FHIR server may support the [_include](http://hl7.org/fhir/search.html#include) search result parameters. If the requester specifies this parameter in the search request, then the FHIR Server will include all referenced resources in the same response. The advantage is that the requester only needs to issue a single query result and the result will contain all the necessary data. The disadvantages are (1) the payload size may increase significantly, (2) the server will need to perform more work and may return the response slower, (3) it is an optional capability of the server.

#### 1:XX.4.1.8 Deployment Considerations of IMR

IMR uses FHIR for defining the format of the diagnostic report as well as the protocol to communicate the report with other systems. Since FHIR is an emerging technology in many existing deployments, several considerations should be taken when deploying IMR in an existing environment:

##### Deploying IMR in environment with existing FHIR infrastructure

IMR can be deployed in an existing FHIR infrastructure. The existing FHIR Server can act as the Report Repository with some additional IMR specific support (e.g. handling of the DiagnosticReport.presentedForm). New Report Creator, Report Reader and Rendered Report Reader are introduced and they interact with the Report Repository.

In this case, many of the *organizational* level resources such as `Patient`, `Organization`, `Practitioner` and `PractitionerRole` may already exist in the Report Repository. Therefore the Report Creator may discover these existing resources prior to create the report. When the Report Creator eventually stores the multimedia report to the Report Repository, the FHIR bundle request can reference these existing organizational resources while creating the new IMR DiagnosticReport resource in the same transaction.

##### Deploying IMR in environment without existing FHIR infrastructure

IMR can be deployed in an environment without an existing FHIR infrastructure, or in an environment in which the existing FHIR infrastructure cannot be used. In this case, a new FHIR infrastructure is required.

Note that in this situation, although the *organizational* level resources such as `Patient`, `Organization`, `Practitioner` and `PractitionerRole` may already exist somewhere (e.g. in EMR), but they may not exist in the new FHIR infrastructure used for IMR. There are two general approaches to address this situation:

- Backfill the new FHIR infrastructure with these existing *organizational* level resources, and introduce a new method for ongoing synchronization. This is out of scope of IMR.
- When the Report Creator stores the multimedia report to the Report Repository, it uses the `ifNoneExist` attribute in [Bundle.request](https://www.hl7.org/fhir/bundle.html) to specify conditional create. A separate method is still required for ongoing synchronization.

### 1:XX.4.2 Use Cases

This profile is focused on encoding multimedia contents in diagnostic reports such that later the user can interact with the embedded multimedia contents in the reports.

Note that the IMR profile is currently focused on intra-enterprise use cases. Other inter-enterprise use cases may be supported in future updates. With this said, the design of the current IMR should not prohibit extending the use cases to inter-enterprise in the future.

#### 1:XX.4.2.1 Use Case 1: Encode and Transmit Multimedia Report

##### 1:XX.4.2.1.1 Encode and Transmit Multimedia Report Use Case Description

During a report dictation session, the Evidence Creator (not part of IMR) conveys multimedia contents to the Report Creator on demand as instructed by the user. (Note that the interaction between the Evidence Creator and Report Creator is out of scope for IMR.) When a dictation session ends, the Report Creator encodes the diagnostic report along with the collected multimedia content. Once completed, the Report Creator stores the multimedia report to the Report Repository, Report Reader and/or Rendered Report Reader.

##### 1:XX.4.2.1.2 Encode and Transmit Multimedia Report Process Flow

Figure 1:XX.4.2.1.2-1 shows the dictation session as background context, and the eventual encoding and transmission of the multimedia report by the Report Creator to the Report Repository.

<div>
{%include uc1-authoring-report.svg%}
</div>
<br clear="all">

**Figure 1:XX.4.2.1.2-1: Encode and Transmit Process Flow in IMR Profile**

#### 1:XX.4.2.2 Use Case 2: Consume and Interact with Multimedia Report by Standalone Report Reader

##### 1:XX.4.2.2.1 Consume and Interact with Multimedia Report by Standalone Report Reader Use Case Description

A clinician wants to review studies and associated diagnostic reports for a patient. She searches the EMR for the patient. The EMR searches for available procedures and studies for the patient as well as any reports available for each procedure and/or study found based on accession number. As a result, the EMR returns a list of studies and associated diagnostic reports for the patient.

> Note that in some cases, for example a group case in which a requested procedure resulted in multiple performed procedures (e.g. chest, abdomen, pelvis). In this case, multiple diagnostic reports for each performed procedure may be created.

Upon reviewing reports for a patient in the EMR which natively supports as an IMR Report Reader, the EMR encounters an IMR multimedia report. It processes the report content and displays the reports with interactive links. The Clinician clicks on the interactive links. The EMR / Report Reader retrieves the rendered images from the Image Manager / Image Archive and displays the images with interactive tools. The Clinicians can navigate the series and see the measurements with annotations as described in the report.

##### 1:XX.4.2.2.2 Consume and Interact with Multimedia Report by Standalone Report Reader Process Flow

Figure 1:XX.4.2.2.2-1 shows how the Clinician can use the EMR with native IMR Report Reader support to interact with the multimedia content available in the report.

<div>
{%include uc2-presenting-interactive-report-standalone.svg%}
</div>
<br clear="all">

**Figure 1:XX.4.2.2.2-1: Consume and Interact with Multimedia Report by Standalone Report Reader Process Flow in IMR Profile**

##### 1:XX.4.2.2.3 Consume and Interact with Multimedia Report by Rendered Report Reader Use Case Description

Alternatively, the EMR supports the IMR Rendered Report Reader. In this case, the EMR extracts and displays the rendered report already embedded in the IMR multimedia report. The Clinician clicks on the interactive links. The EMR / Rendered Report Reader invokes the links and displays the rendered content.

##### 1:XX.4.2.2.4 Consume and Interact with Multimedia Report by Rendered Report Reader Process Flow

Figure 1:XX.4.2.2.4-1 shows how the Clinician can use the EMR with a native IMR Rendered Report Reader support to interact with the multimedia content available in the report.

<div>
{%include uc2a-presenting-interactive-report-presentedform.svg%}
</div>
<br clear="all">

**Figure 1:XX.4.2.2.4-1: Consume and Interact with Multimedia Report by Rendered Report Reader Process Flow in IMR Profile**

#### 1:XX.4.2.3 Use Case 3: Consume and Interact with Multimedia Report by Report Reader with Integrated Image Display Invoker

##### 1:XX.4.2.3.1 Consume and Interact with Multimedia Report by Report Reader with Integrated Image Display Invoker Use Case Description

The functionality of this use case is the same as in Use Case 2. The difference is that the IMR Report Reader does not natively support image viewing capability. Instead, it is grouped with an Image Display Invoker actor to launch an Image Display that can do so. 

Upon reviewing reports for a patient in the EMR which supports as an IMR Report Reader with integrated Image Display Invoker, the EMR encounters an IMR multimedia report. It displays the reports with interactive links to the multimedia content. The Clinician clicks on the interactive links. The EMR / Report Reader launches the integrated Image Display Invoker which in turn invokes the configured Image Display in context based on the information in the link. The Image Display retrieves and displays the images with interactive tools. The Clinicians can navigate the series and see the measurements with annotations as described in the report.

##### 1:XX.4.2.3.2 Consume and Interact with Multimedia Report by Report Reader with Integrated Image Display Invoker Process Flow

Figure 1:XX.4.2.3.2-1 shows how the Clinician can use the EMR that supports IMR Report Reader with integrated Image Display Invoker to interact with the multimedia content available in the report.

<div>
{%include uc3-presenting-interactive-report-EMR.svg%}
</div>
<br clear="all">

**Figure 1:XX.4.2.3.2-1: Consume and Interact with Multimedia Report by Report Reader with Integrated Image Display Invoker Process Flow in IMR Profile**

#### 1:XX.4.2.4 Use Case 4: Consume and Interact with Multimedia Report for Prior Study by Radiologist

##### XX.4.2.4.1 Consume and Interact with Multimedia Report for Prior Study by Radiologist Use Case Description

A radiologist is in the process of dictating a study. Relevant prior studies are displayed along with the current study. The prior studies have associated multimedia reports. The Report Reader integrated with an Image Display displays the multimedia reports to the radiologist with interactive links. When the Radiologist clicks on the links, the Report Reader triggers the viewport in the Image Display currently showing the prior study to show the specific image in which the measurements are derived from. The Radiologist can continue and re-measure to confirm the data submitted by the resident.

##### 1:XX.4.2.4.2 Consume and Interact with Multimedia Report for Prior Study by Radiologist Process Flow

Figure 1:XX.4.2.4.2-1 shows how the Radiologist can use the PACS workstation (Image Display) that is integrated with IMR Report Reader to interact with the multimedia content available in the report.

<div>
{%include uc4-presenting-interactive-report-PACS.svg%}
</div>
<br clear="all">

**Figure 1:XX.4.2.4.2-1: Consume and Interact with Multimedia Report for Prior Study by Radiologist Process Flow in IMR Profile**

A similar workflow can also happen in the clinician reading context. In this case, a clinician is reviewing reports and studies for a patient in the EMR, but the EMR does not support as an IMR Report Reader. It displays the report as normal text report without the multimedia content. The clinician clicks on a study, the integrated Image Display Invoker launches the configured Image Display in context. However, this Image Display also fetches the report as part of its image viewing process, and this Image Display is also integrated with an IMR Report Reader. It identifies that the study has an associated multimedia report. It displays the study along with the report with interactive links to the multimedia content. The Clinician clicks on the interactive links. The integrated Report Reader retrieves the corresponding images to which the measurements are derived from and display them in the Image Display. The clinician can interact with the images to see the annotation.

##### 1:XX.4.2.4.3 Consume and Interact with Multimedia Report by Report Reader with Integrated Image Display Process Flow

Figure 1:XX.4.2.4.3-1 shows how the Clinician can use the EMR that supports IMR Report Reader with integrated Image Display to interact with the multimedia content available in the report.

<div>
{%include uc4b-presenting-interactive-report-EMR-use-IID.svg%}
</div>
<br clear="all">

**Figure 1:XX.4.2.4.3-1: Consume and Interact with Multimedia Report by Report Reader with Integrated Image Display Process Flow in IMR Profile**

## 1:XX.5 IMR Security Considerations

Refer to RAD TF-1x: Appendix F “Security Environment Considerations”.

Protected Healthcare Information (PHI) is present in the DICOM instances being stored,
retrieved, processed, and displayed, as well as in the API being invoked.

See ITI TF-2: [Appendix Z.8 “Mobile Security Considerations”](https://profiles.ihe.net/ITI/TF/Volume2/ch-Z.html#z.8-mobile-security-considerations) for FHIR based transactions.

General [Security and Privacy guidance](http://hl7.org/fhir/secpriv-module.html) is provided in the FHIR Specification.

### 1:XX.5.1 Security Considerations for Actors

This profile strongly recommends all actors group with an ITI ATNA Secure Application or
Secure Node Actor using the Radiology Audit Trail Option.

The ATNA Profile requires actors to implement:
- Record Audit Event [ITI-20] transaction which would record when and where analysis
785 results are distributed and displayed.
- Authenticate Node [ITI-19] transaction to further ensure the integrity of transactions via
node authentication and communication encryption.

Furthermore, for the FHIR-based transactions, this profile strongly recommends the use of ITI Internet User Authroization (IUA) to ensure that communications are only allowed for authenticated and authorized users and/or systems.

### 1:XX.5.2 Security Considerations for Multimedia Reports

Multimedia report instances as defined in this profile contain personal demographic information
and clinical information. It is appropriate for products implementing the Interactive Multimedia Report Profile to include appropriate PHI controls. Specifying such mechanisms and features is outside the scope of this profile.

The rendered report attached in the DiagnosticReport resource may be referenced by a URL. Furthermore, the rendered report may includes hyperlinks for image references. It is recommended for any deployment to have network configurations that only allow trusted known clients (e.g. by IP address or subnet) to access, and block unknown clients. In addition, the requests to these hyperlinks should be authorized. Unauthorized access should be rejected.

The Rendered Report Readers should verify if these URLs are legitimate and from a trusted source, minimizing the chance of phishing attack and executing malicious script embedded inside a report.

## 1:XX.6 IMR Cross-Profile Considerations

**Scheduled Workflow (SWF.b)**: An Image Display may be grouped with an IMR Report Reader to enhance the report viewing capability for prior studies.

**Results Distribution (RD)**: A Report Creator that supports the HL7 Text Report Option can use Result Distribution to send the text report to other consumers.

**Basic Image Review (BIR)**: A Report Reader may be grouped with an Image Display in BIR to provide the required image display functionality.

**Management of Radiology Report Templates (MRRT)**: A Report Creator in MRRT may be grouped with a Report Creator in IMR. As a result, the grouped Report Creator can use the report templates to assist the radiologist in creating the diagnostic report, and capture the final report in the IMR DiagnosticReport format.

**AI Result (AIR)**: An Evidence Creator may be grouped with an IMR Report Creator to include AI results in the diagnostic report. An Image Display in AIR may be grouped with an IMR Image Display or Report Reader to show the interactive AI results.
