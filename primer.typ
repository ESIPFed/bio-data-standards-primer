#import "template.typ": bds_primer
#let data = yaml("primer_data.yml")

#show: bds_primer.with(data)