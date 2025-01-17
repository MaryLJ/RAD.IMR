### 2:4.Y5.1 Scope

This transaction is used to present the images referenced in a multimedia report to someone, such as a radiologist or a clinician, in such a way that permits the user to interact with the images.

This transaction is not a typical IHE transaction between two devices; the primary focus is on the required behavior of the display rather than messaging between two actors. This can be thought of as an “informational transaction” between a display device and a user.

The specification is about the baseline display behaviors required for image references included in multimedia reports. As with many IHE specifications, the display may have behaviors in addition to those required by this transaction.

### 2:4.Y5.2 Actors Roles

The roles in this transaction are defined in the following table and may be played by the actors shown here:

**Table: Actor Roles**

**Introduce Display role**

| Role      | Description                                   | Actor(s)          |
|-----------|-----------------------------------------------|-------------------|
| Display | Presents images to a user, such as a radiologist    | Report Reader <br> Image Display |
{: .grid}

Transaction text specifies behavior for each role. The behavior of specific actors may also be specified when it goes beyond that of the general role.

### 2:4.Y5.3 Referenced Standards

**DICOM PS3.3**: A. Composite Information Object Definitions

### 2:4.Y5.4 Messages

<div>
{%include RAD-Y5-seq.svg%}
</div>
<br clear="all">

**Figure 2:3.Y5.4-1: Interaction Diagram**

#### 2:4.Y5.4.1 Display Images Message
The Display presents the images referenced in a report to the user.

##### 2:4.Y5.4.1.1 Trigger Events

A user or an automated function determines that one or more images should be presented.

##### 2:4.Y5.4.1.2 Message Semantics

The images are encoded as DICOM SOP instances.

Display of images does not depend on how the images were obtained by the Display.

#### 2:4.Y5.4.1.3 Expected Actions (i.e. Display Requirements)

The behaviors in this section are specified as baseline capabilities. Displays may have additional or alternative capabilities that may be invoked or configured.

This transaction does not specify particular SOP classes that must be displayed.

The Image Display shall display all requested DICOM objects for which it claims compliance in any IHE Content or Workflow profile or DICOM Conformance Statement. This includes images (single frame and multi-frame), DICOM SR (including Evidence Documents and Key Image Notes), and Presentation State objects with their referenced images. All supported DICOM information objects included in the selected studies shall be displayable, except images identified as “for processing”, raw data instances, and instances of private SOP Classes. It is permissible to display “for processing”, raw data instances, and instances of private SOP Classes. There are no specific requirements placed on the manner in which non-image objects are displayed.

> Note: Grouping with other profiles, such as CPI, SINR, and KIN, may require more specific behavior for non-image objects.

The Display shall support image viewing capabilities as defined in [Basic Image Review (BIR)](https://www.ihe.net/uploadedFiles/Documents/Radiology/IHE_RAD_Suppl_BIR.pdf) Profile, Section 4.16.4.2.2.5 as defined in the Table 2:4.Y5.4.1.3-1:

Table 2:4.Y5.4.1.3-1: Image Viewing Capability Required in IMR
| Capability | BIR Reference | Requirement |
|------------|---------------|-------------|
| Simple Restricted Feature Set | Section 4.16.5.2.2.5.1 | Not Required |
| Layout, Tiling, Selection, Rotation and Flipping | Section 4.16.5.2.2.5.2 | Required only Rotation and Flipping |
| Navigation | Section 4.16.5.2.2.5.3 | Not Required |
| Windowing and Rendering | Section 4.16.4.2.2.5.4 | Required |
| Scrolling | Section 4.16.4.2.2.5.5 | Required if IMR Series/Study Navigation Option is supported |
| Zooming and Panning | Section 4.16.4.2.2.5.6 | Required |
| Laterality and Spatial Cross-Referencing | Section 4.16.4.2.2.5.7 | Required only Laterality |
| Annotation | Section 4.16.4.2.2.5.8 | Required |
| Cine | Section 4.16.4.2.2.5.9 | Required if the Display supports sop classes that cine is applicable |
| Measurements | Section 4.16.4.2.2.5.10 | Required |
| Viewport and Tool Section | Section 4.16.4.2.2.5.11 | Not Required |
| Report Display | Section 4.16.4.2.2.5.12 | Not Required |
| Tool Icons and Actions | Section 4.16.4.2.2.5.13 | Not Required |
{: .grid}

The Display may provide basic viewing tools for the user to interactive with the images.

> Note that the Display is only required to display objects specifically referenced in the DiagnosticReport resource.
>
> Multiplanar reconstruction, or MPR, involves the process of converting data from an imaging modality acquired in a certain plane, usually axial, into another plane such as coronal or sagittal or oblique. It is most commonly performed with thin-slice data from volumetric CT in the axial plane, but it may be accomplished with scanning in any plane and whichever modality capable of cross-sectional imaging, including magnetic resonance imaging (MRI).
>
> Although MPR is a feature available in many PACS implementations, it is a advanced operation that is computational intensive. For the interactive image viewing capability on interactive multimedia report, MPR is not expected to be available. If viewing of the images from different planes is desirable, then the acquired data should be reconstructed to other planes and then be saved as separate set of images. These new set of reconstructed images can then be referenced in the DiagnosticReport resource.
>
> The Display is not required to support reconstruction.

### 2:4.Y5.5 Security Considerations

This transaction involves presenting DICOM objects that typically constitute personal health
information (PHI) to human observers who are typically clinicians. Typical access controls and
audit trails in accordance with local policies would be appropriate.

#### 2:4.Y5.5.1 Security Audit Considerations

The Radiology Audit Trail Option in the ITI Audit Trail and Node Authentication Profile (ITI TF-1:9) defines audit requirements for IHE Radiology transactions. See RAD TF-3: 5.1.

#### 2:4.Y5.5.2 Display Specific Security Considerations

Since this transaction involves the display of PHI, it may be reasonable for the Displays to implement typical access controls for patient records, such as logins for users and role-based access policies. Since this transaction involves parsing datasets generated by other systems, it may be reasonable for the Displays to implement basic digital hygiene, such as sanitizing datasets to avoid malicious executable scripts that might be executed by a browser-based viewer.
