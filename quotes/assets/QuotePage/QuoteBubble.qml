/* Copyright (c) 2012 Research In Motion Limited.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import bb.cascades 1.0

// This is the speech bubble with the quote and the name underneath it.

Container {
    id: quoteBubble
    property bool editMode: false
    property string firstName: "John"
    property string lastName: "Doe"
    property alias quoteText: longText.text
    signal editCancel();
    signal editUpdate(string firstName, string lastName, string quote);
    
    topPadding: 30
    bottomPadding: topPadding
    rightPadding: topPadding
    leftPadding: topPadding

    // The two buttons for cancel and add/update actions, shown in edit mode
    EditControls {
        id: editControls
        visible: quoteBubble.editMode
        
        onCancel: {
            // Revert back to the data that is stored in the _contentView context property.
            quoteBubble.editMode = false;
            quoteBubble.editCancel();
        }
        
        onUpdate: {
            // Update to the values entered in the fields.
            quoteBubble.editMode = false;
            quoteBubble.editUpdate(editName.firstName, editName.lastName, longText.text);
        }
    }

    // The actual quote
    Container {
        horizontalAlignment: HorizontalAlignment.Center
        layout: DockLayout {
        }

        // The bubble image behind the quote. Since the image will scale due to
        // different lengths of the quote a nine-sliced image is used to ensure
        // only the middle part (the white area) is scaled (see images/border_bubble.amd).
        ImageView {
            imageSource: "asset:///images/border_bubble.amd"
            verticalAlignment: VerticalAlignment.Fill
            horizontalAlignment: HorizontalAlignment.Fill
        }

        // TextArea that is put in a Container to add padding around it
        Container {
            topPadding: 54
            bottomPadding: 85
            rightPadding: 30
            leftPadding: rightPadding
            
            TextArea {
                id: longText
                preferredWidth: 520
                editable: quoteBubble.editMode
                input.flags: TextInputFlag.SpellCheckOff
            }
        } // Text area Container
    } // Quote Container

    // The name of the person who wrote/said the quote
    Container {
        topPadding: 15
        layout: DockLayout {
        }
        Label {
            id: nameLabel
            visible: ! quoteBubble.editMode

            // The person behind the quote who's first and last name are data bound in C++.
            text: quoteBubble.firstName + " " + quoteBubble.lastName
            textStyle.base: quoteStyleLightBody.style
        }

        // Edit mode for name
        EditName {
            id: editName
            visible: quoteBubble.editMode
            firstName: quoteBubble.firstName
            lastName: quoteBubble.lastName

            onEnableSave: {
                // A last name has to be entered disable buttons and text areas as long as the length is zero.
                if (enable) {
                    editControls.updateEnabled = true;
                    longText.enabled = true;
                } else {
                    editControls.updateEnabled = false;
                    longText.enabled = false;
                }
            }
        } // EditName
    } // Name Container
}// Main Container
