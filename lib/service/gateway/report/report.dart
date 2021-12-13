import 'package:iris/service/gateway/report/save_file_mobile.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:syncfusion_officechart/officechart.dart';
import 'package:collection/collection.dart';

class ReportDataService {
  Future<void> generatExcel(List<String> dateSelected, List<num> tempAverage,
      List<num> min, List<num> max, String gateway, String station) async {
    int length = dateSelected.length + 28;

    final Workbook workbook = Workbook(0);
    final Worksheet sheet1 = workbook.worksheets.addWithName('Temperatura');
    sheet1.showGridlines = false;

    sheet1.enableSheetCalculations();

    //Largura
    sheet1.getRangeByIndex(1, 1).columnWidth = 6.67;
    sheet1.getRangeByIndex(1, 2).columnWidth = 20;
    sheet1.getRangeByIndex(1, 3).columnWidth = 14.89;
    sheet1.getRangeByIndex(1, 4).columnWidth = 8.11;
    sheet1.getRangeByIndex(1, 5).columnWidth = 8.11;
    sheet1.getRangeByIndex(2, 2).columnWidth = 20;
    sheet1.getRangeByIndex(2, 3).columnWidth = 14.89;
    sheet1.getRangeByIndex(2, 4).columnWidth = 8.11;
    sheet1.getRangeByName("B29:E" + length.toString()).columnWidth = 14.89;

    //Altura
    sheet1.getRangeByIndex(1, 1).rowHeight = 37.5;
    sheet1.getRangeByIndex(2, 1).rowHeight = 15;
    sheet1.getRangeByIndex(3, 1).rowHeight = 37.5;
    sheet1.getRangeByIndex(3, 1).rowHeight = 41.25;

    //Data

    sheet1.getRangeByIndex(1, 2).text = 'TEMPERATURA MÉDIA';
    sheet1.getRangeByIndex(1, 4).text = 'EXIBIÇÃO DE GRÁFICO';
    sheet1.getRangeByIndex(1, 7).text = 'CONTROLE DE DADOS';

    sheet1.getRangeByIndex(3, 2).text = tempAverage.average.toString();
    sheet1.getRangeByIndex(3, 4).text = 'DIARIO';
    sheet1.getRangeByIndex(3, 7).text = 'TEMPERATURA';

    sheet1.getRangeByIndex(26, 2).text =
        'ESTAÇÃO $station, PERTECENTE A $gateway';

    sheet1.getRangeByIndex(28, 2).text = 'DATA';
    sheet1.getRangeByIndex(28, 3).text = 'MÉDIA';
    sheet1.getRangeByIndex(28, 4).text = 'MÍNIMA';
    sheet1.getRangeByIndex(28, 5).text = 'MAXÍMA';

    sheet1.importList(dateSelected, 29, 2, true);
    sheet1.importList(tempAverage, 29, 3, true);
    sheet1.importList(min, 29, 4, true);
    sheet1.importList(max, 29, 5, true);

//Cell Style

    final Style style2 = workbook.styles.add('Style2');
    style2.fontColor = '#F7B02B';
    style2.backColor = '#2D2F2E';
    style2.fontSize = 13;

    final Style style1 = workbook.styles.add('Style1');
    style1.fontColor = '#FFFFFF';
    style1.backColor = '#2D2F2E';
    style1.fontSize = 16;
    style1.borders.all.color = "#92D050";

    final Style style3 = workbook.styles.add('Style3');
    style3.fontColor = '#F7B02B';
    style3.backColor = '#2D2F2E';
    style3.fontSize = 18;

    final Style style4 = workbook.styles.add('Style4');
    style4.fontColor = '#FFFFFF';
    style4.backColor = '#2D2F2E';
    style4.fontSize = 15;
    style4.hAlign = HAlignType.right;
    style4.borders.bottom.color = '#FFFFFF';

    final Style styledata = workbook.styles.add('Styledata');
    styledata.fontColor = '#FFFFFF';
    styledata.backColor = '#2D2F2E';
    styledata.fontSize = 13;

    sheet1.getRangeByName('A1:Z500').cellStyle.backColor = '#2D2F2E';

    sheet1.getRangeByIndex(1, 2).cellStyle = style2;
    sheet1.getRangeByIndex(1, 4).cellStyle = style2;
    sheet1.getRangeByIndex(1, 7).cellStyle = style2;

    sheet1.getRangeByIndex(3, 2).cellStyle = style1;
    sheet1.getRangeByIndex(3, 4).cellStyle = style1;
    sheet1.getRangeByIndex(3, 7).cellStyle = style1;

    sheet1.getRangeByIndex(26, 2).cellStyle = style3;

    sheet1.getRangeByIndex(28, 2).cellStyle = style4;
    sheet1.getRangeByIndex(28, 3).cellStyle = style4;
    sheet1.getRangeByIndex(28, 4).cellStyle = style4;
    sheet1.getRangeByIndex(28, 5).cellStyle = style4;
    sheet1.getRangeByIndex(28, 6).cellStyle = style4;

    sheet1.getRangeByName("B29:E" + length.toString()).cellStyle = styledata;

    //Chart

    final ChartCollection charts = ChartCollection(sheet1);
    final Chart chart = charts.add();
    chart.chartType = ExcelChartType.lineStacked;
    chart.linePattern = ExcelChartLinePattern.solid;
    chart.dataRange = sheet1.getRangeByName("B29:C" + length.toString());
    chart.isSeriesInRows = false;
    chart.chartTitle = 'Temperatura';
    chart.chartTitleArea.bold = true;
    chart.chartTitleArea.size = 16;
    chart.topRow = 5;
    chart.primaryValueAxis.hasMajorGridLines = false;
    chart.plotArea.linePattern = ExcelChartLinePattern.longDash;
    chart.plotArea.linePatternColor = "#404040";
    chart.bottomRow = 25;
    chart.leftColumn = 2;
    chart.rightColumn = 10;
    sheet1.charts = charts;

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    //Launch file.
    await FileSaveHelper.saveAndLaunchFile(bytes, '$station.xlsx');
  }

  Future<void> launch(List<int> bytes) async {}
}
