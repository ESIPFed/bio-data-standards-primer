#let bds_primer(data, body) = {
  // 1. COLORS
  let deepGreen = rgb("#07401b")
  let cyan = rgb("#5be1e6")
  let brightBlue = rgb("#38b7fe")
  let deepBlue = rgb("#153c8d")

  // 2. GLOBAL SETTINGS
  set page(
    paper: "us-legal",
    margin: (top: 0in, x: 0in, bottom: 0in), // Keep margins at zero
    footer: none // <--- Tell Typst NOT to manage the footer automatically
  )
  
  set text(font: ("Montserrat", "Arial"), size: 8.5pt)
  set par(leading: 0.55em)

  // 3. THE HELPER FUNCTION
  let format-item(item) = {
    if type(item) == dictionary {
      link(item.url)[#underline(stroke: 0.5pt + cyan)[#text(fill: cyan, weight: 700)[#item.text]]]
    } else {
      item
    }
  }

  // 4. REFINED HEADER ZONE (The Three-Story Building)
  rect(
    width: 100%, 
    fill: brightBlue, 
    // x: 0in lets the blue hit the paper edges; top pushes the tagline down
    inset: 0in, 
    stroke: none
  )[
    #grid(
      columns: (1fr),
      rows: (auto, auto, auto), 
      row-gutter: 0.2in, // Vertical gap between Tagline and Title
      
      // STORY 1: The Tagline (The Hammer Fix)
      [
        #block(width: 100%)[
          #set align(right)
          // We use 'move' to nudge it if padding still feels restricted
          #pad(right: 0in, top: 0in)[ 
            #rect(fill: deepGreen, inset: 14pt, radius: 2pt)[
              #set align(center)
              #text(size: 10pt, weight: 900, fill: cyan)[#data.metadata.tagline]
            ]
          ]
        ]
      ],

      // STORY 2: The Titles (Centered)
      [
        #set align(center)
        #pad(x: 0.5in, y: 16pt)[
          #text(size: 32pt, weight: 800, fill: deepBlue)[#upper([#data.metadata.main_title])] \
          #v(0.02in)
          #text(size: 18pt, weight: 400, fill: deepBlue)[#data.metadata.subtitle]
          #v(-0.25in) //adjust space between subtitle and core message
        ]
      ],

      // STORY 3: The Core Message (Dark Blue Foundation)
      [
        #set align(center)
        #rect(width: 100%, fill: brightBlue, inset: (x: 0.5in, y: 12pt), stroke: none)[
          #text(fill: deepBlue, size: 10pt, weight: 800)[#data.metadata.core_message]
        ]
      ]
    )
  ]

  v(-11pt) // Pull grid closer

  // 6. UNIFIED CONTENT GRID
  let grid-items = ()

  // Row 0: The Floating Header Boxes (Pinned to the Top of the Columns)
  
  // LEFT HEADER (Row 0, Column 0)
  grid-items.push(block(width: 100%, inset: (left: 2pt, right: 10pt, top: 2pt, bottom: 10pt))[
    #set align(left) // <--- Pins the rectangle to the left
    #rect(fill: deepGreen, width: 70%, inset: 8pt, radius: 2pt)[
      #set align(left) // Keeps the text centered INSIDE the green box
      #text(weight: 500, size: 14pt, fill: cyan)[#upper(data.metadata.left_header)]
    ]
  ])

  // RIGHT HEADER (Row 0, Column 1)
  grid-items.push(block(width: 100%, inset: (left: 2pt, right: 0.5in, top: 2pt, bottom: 10pt))[
    #set align(left) // <--- Pins the rectangle to the left
    #rect(fill: cyan, width: 70%, inset: 8pt, radius: 2pt)[
      #set align(left)
      #text(weight: 500, size: 14pt, fill: deepGreen)[#upper(data.metadata.right_header)]
    ]
  ])

  for section in data.sections {
    // Left Cell
    grid-items.push(block(width: 100%, inset: (left: 0.5in, right: 15pt, y: 12pt, bottom: 20pt))[
      #set text(fill: deepGreen)
      #set align(center)
      #text(weight: 800, size: 14pt)[#upper([#section.left_column.goal])] \
      #v(2pt)
      // Add style: "italic" right here:
      #text(size: 8.5pt, style: "italic")[#section.left_column.benefit]
    ])
    
    // Right Cell
    grid-items.push(block(width: 100%, inset: (left: 15pt, right: 0.5in, y: 15pt, bottom: 20pt))[
      #set text(fill: cyan, size: 10pt)
      #set align(center)
      #text(weight: 800, size: 14pt)[#upper([#section.right_column.title])]
      #v(2pt)
      #let lines = ()
      #if "standards" in section.right_column { lines.push([*Standards:* #section.right_column.standards.map(format-item).join(", ")]) }
      #if "repositories" in section.right_column { lines.push([*Examples:* #section.right_column.repositories.map(format-item).join(", ")]) }
      #if "vocabularies" in section.right_column { lines.push([*Vocabularies:* #section.right_column.vocabularies.map(format-item).join(", ")]) }
      #if "taxonomic" in section.right_column { lines.push([*Authorities:* #section.right_column.taxonomic.map(format-item).join(", ")]) }
      #if "habitat" in section.right_column { lines.push([*Habitat:* #section.right_column.habitat.map(format-item).join(", ")]) }
      #lines.join([\ ])
      // Checklist Items (Inside the right-hand column)
      #if "checklist" in section.right_column {
        v(4pt)
        // Reset alignment to left for the bullets
        set align(left) 
        
        for item in section.right_column.checklist {
          // Use a tight 2-column grid to "hang" the bullet
          grid(
            columns: (12pt, 1fr), 
            gutter: 0pt,
            // The bullet in column 1, the text in column 2
            [-], [#text(size: 10pt)[#format-item(item)]]
          )
          v(2pt) // Small gap between bullet items
        }
      }
    ])
  }

  // Draw the Grid with row-gutters and separators
  block(breakable: true)[
    #grid(
      columns: (1fr, 1fr),
      // CHANGE THIS: Remove the 'if row == 0 { white }' part
      fill: (col, row) => {
        if col == 0 { cyan } 
        else { deepGreen }
      },
      stroke: (x, y) => (
        bottom: if y > 0 { 2pt + brightBlue } else { 0pt }
      ),
      ..grid-items
    )

    #v(-10pt)
  ]

  // --- 7. MIX AND MATCH & REQUIREMENTS (Bottom Checklist) ---
  v(-1.2pt) // Stitching the seam to the grid above
  
  block(width: 100%, fill: brightBlue, inset: (top: 0.25in, bottom: 0.25in, x: 0.5in), stroke: none)[
    #set text(fill: deepGreen)
    #grid(
      columns: (1fr, 1fr),
      column-gutter: 30pt,
      // LEFT COLUMN: Disclaimer
      [
        #set align(left)
        #text(size: 14pt, weight: 800)[#upper(data.repository_disclaimer.title)]
        #v(6pt)
        #text(size: 10pt)[#data.repository_disclaimer.text]
      ],
      // RIGHT COLUMN: Requirements
      [
        #set align(left)
        #text(size: 14pt, weight: 800)[#upper(data.repository_requirements.title)]
        #v(6pt)
        #set list(indent: 0pt, body-indent: 8pt, marker: sym.square.filled)
        #for node in data.repository_requirements.nodes [
          - #text(size: 10pt)[*#node.name:* #node.requirements.join(", ")]
        ]
      ]
    )
  ]

  v(-1pt) // The "Seam" Nudge to glue the blue to the cyan

  // --- 8. THE INTEGRATED FOOTER (Stacked & Centered) ---
  v(-15pt) // Tiny nudge to ensure no white line between blue and cyan
  
  // 'height: 1fr' expands the block to fill the rest of the page
  block(width: 100%, height: 1fr, fill: cyan, inset: (x: 0.5in, top: 20pt, bottom: 20pt), stroke: none)[
    #set align(center)
    #set text(size: 12pt, fill: deepGreen, font: "Montserrat", weight: 600)
    
    #stack(dir: ttb, spacing: 20pt)[
        To get involved,
        #v(-10pt) // Tighter gap for the "To get involved" label
        Visit: #link(data.primer_footer.get_involved) 
    ][
        #link(data.primer_footer.fairsharing)
    ]
  ]

}