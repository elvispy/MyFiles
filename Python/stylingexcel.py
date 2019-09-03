import xlwt

styles = dict(
    bold = 'font: bold 1',
    italic = 'font: italic 1',
    # Wrap text in the cell
    wrap_bold = 'font: bold 1; align: wrap 1;',
    # White text on a blue background
    reversed = 'pattern: pattern solid, fore_color blue; font: color white;',
    # Light orange checkered background
    light_orange_bg = 'pattern: pattern fine_dots, fore_color white, back_color orange;',
    # Heavy borders
    bordered = 'border: top thick, right thick, bottom thick, left thick;',
    # 16 pt red text
    big_red = 'font: height 320, color red;',
)

book = xlwt.Workbook()
sheet = book.add_sheet("Style demo")

for idx, k in enumerate(sorted(styles)):

    style = xlwt.easyxf(styles[k])
    sheet.write(idx, 0, k)
    sheet.write(idx, 1, styles[k], style)




style = xlwt.easyxf('pattern: pattern solid, fore_color light_blue; font: color white,\
                    name Arial, height 210, bold 1; align: wrap off,vert centre, horiz center;')

sheet.write(8, 1, "Esto es un estilo de prueba N° 1", style)

book.save("Example.xls")
import xlrd

wb = xlrd.open_workbook("Example.xls", formatting_info = True)
sheet = wb.sheet_by_name("Style demo")

cell = sheet.cell(0,1)

print("cell.xf_index is ", cell.xf_index)

fmt = wb.xf_list[cell.xf_index]

print(" type(fmt) is ", type(fmt))

print()

print("fmt.dump()")

fmt.dump()
