#let bds_primer(data, body) = {
  // 1. COLORS
  let deepGreen = rgb("#07401b")
  let cyan = rgb("#5be1e6")
  let brightBlue = rgb("#38b7fe")
  let deepBlue = rgb("#153c8d")

  // 2. GLOBAL SETTINGS
  set page(
    paper: "us-legal",
    margin: (x: 0in, y: 0in),
    footer: rect(width: 100%, fill: cyan, inset: (x: 0.5in, y: 8pt), stroke: none)[
      #set align(center)
      #set text(size: 8pt, fill: deepGreen, font: "Montserrat")
      #grid(columns: (1fr, 1fr),
        [Visit: #link(data.primer_footer.get_involved)],
        [Resources: #link(data.primer_footer.fairsharing)]
      )
    ]
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

  v(-4pt) // Pull core message closer


  v(-4pt) // Pull grid closer

  // 6. UNIFIED CONTENT GRID
  let grid-items = ()

  // Row 0: Floating Header Boxes (3/4 width, inverted colors)
  // Left Header: Deep Green box, Cyan text
  grid-items.push(block(width: 100%, inset: (left: 0.5in, right: 15pt, y: 10pt))[
    #rect(fill: deepGreen, width: 75%, inset: 8pt, radius: 2pt)[
      #text(weight: 800, size: 11pt, fill: cyan)[#data.metadata.left_header]
    ]
  ])
  // Right Header: Cyan box, Deep Green text
  grid-items.push(block(width: 100%, inset: (left: 15pt, right: 0.5in, y: 10pt))[
    #rect(fill: cyan, width: 75%, inset: 8pt, radius: 2pt)[
      #text(weight: 800, size: 11pt, fill: deepGreen)[#data.metadata.right_header]
    ]
  ])

  for section in data.sections {
    // Left Cell
    grid-items.push(block(width: 100%, inset: (left: 0.5in, right: 15pt, y: 12pt))[
      #set text(fill: deepGreen)
      #text(weight: 800, size: 10pt)[#section.left_column.goal] \
      #v(2pt)
      // Add style: "italic" right here:
      #text(size: 8.5pt, style: "italic")[#section.left_column.benefit]
    ])
    
    // Right Cell
    grid-items.push(block(width: 100%, inset: (left: 15pt, right: 0.5in, y: 15pt))[
      #set text(fill: cyan, size: 8.5pt)
      #text(weight: 800, size: 10pt)[#section.right_column.title]
      #v(2pt)
      #let lines = ()
      #if "standards" in section.right_column { lines.push([*Standards:* #section.right_column.standards.map(format-item).join(", ")]) }
      #if "repositories" in section.right_column { lines.push([*Examples:* #section.right_column.repositories.map(format-item).join(", ")]) }
      #if "vocabularies" in section.right_column { lines.push([*Vocabularies:* #section.right_column.vocabularies.map(format-item).join(", ")]) }
      #if "taxonomic" in section.right_column { lines.push([*Authorities:* #section.right_column.taxonomic.map(format-item).join(", ")]) }
      #if "habitat" in section.right_column { lines.push([*Habitat:* #section.right_column.habitat.map(format-item).join(", ")]) }
      #lines.join([\ ])
      #if "checklist" in section.right_column {
        v(4pt)
        for item in section.right_column.checklist {
          grid(columns: (10pt, 1fr), [-], [ #format-item(item) ])
        }
      }
    ])
  }

  // Draw the Grid with row-gutters and separators
  block(breakable: true)[
    #grid(
      columns: (1fr, 1fr),
      // Background colors for the columns
      fill: (col, row) => {
        if row == 0 { white } 
        else if col == 0 { cyan } 
        else { deepGreen }
      },
      // Horizontal lines between rows
      stroke: (x, y) => (
        bottom: if y > 0 { 2pt + brightBlue } else { 0pt }
      ),
      ..grid-items
    )
  ]

  // 7. BOTTOM ZONE
  rect(width: 100%, fill: brightBlue, inset: (x: 0.5in, y: 20pt), stroke: none)[
    #set text(fill: deepGreen)
    #grid(columns: (1.2fr, 2.2fr), gutter: 20pt,
      [#text(weight: 900, size: 10pt)[#data.repository_disclaimer.title] \ #v(4pt) #data.repository_disclaimer.text],
      [
        #text(weight: 900, size: 10pt)[#data.repository_requirements.title]
        #v(6pt)
        #grid(columns: (1fr, 1fr, 1fr, 1fr, 1fr), gutter: 4pt,
          ..data.repository_requirements.nodes.map(node => rect(width: 100%, fill: white, inset: 4pt, stroke: 0.5pt + deepGreen, radius: 2pt)[
            #set align(center)
            #text(weight: 800, size: 7pt)[#node.name] \
            #v(1pt)
            #set text(size: 6pt)
            #node.requirements.join("\n")
          ])
        )
      ]
    )
  ]
}