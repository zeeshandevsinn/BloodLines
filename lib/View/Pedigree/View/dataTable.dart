// ignore_for_file: must_be_immutable

import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/loader.dart';
import 'package:bloodlines/Components/utils.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class DropdownStyle {
  /// Colors
  final Color? textColor;
  final Color? triggerIconColor;
  final Color? dropdownCanvasColor;

  /// FontSizes / Icon Sizes
  final double? textSize;
  final double? triggerIconSize;

  DropdownStyle({
    this.textColor,
    this.triggerIconColor,
    this.dropdownCanvasColor,
    this.textSize,
    this.triggerIconSize,
  });
}

/// For Previous / Next styling
class PreviousNextStyle {
  final Color? iconColor;
  final double? iconSize;

  PreviousNextStyle({
    this.iconColor,
    this.iconSize,
  });
}

class PaginatedDataTableCustom extends StatefulWidget {
  final String? nextPage;
  final String? previousPage;
  final String? firstPage;
  final List<Widget>? actions;
  final List<DataColumn>? columns;
  final int sortColumnIndex;
  final VoidCallback? onTapForward;
  final VoidCallback? onTapBackward;
  final VoidCallback? onTapFirstPage;
  final bool? sortAscending;
  final ValueSetter<bool?>? onSelectAll;
  final double? dataRowHeight;
  final double? headingRowHeight;
  final double? horizontalMargin;
  final double? columnSpacing;
  final bool? showCheckboxColumn;
  final int? initialFirstRowIndex;
  final ValueChanged<int>? onPageChanged;
  final int? rowsPerPage;
  final int? total;
  static const int defaultRowsPerPage = 10;
  final List<int>? availableRowsPerPage;
  final ValueChanged<int?>? onRowsPerPageChanged;
  final DataTableSource? source;
  final TextStyle? footerStyle;
  final DropdownStyle? dropdownStyle;
  final PreviousNextStyle? previousNextStyle;
  final bool? footer;
  final int? from;
  final int? to;
  bool isDashboardFooter = false;
  final GestureTapCallback? onTap;

  PaginatedDataTableCustom({
    Key? key,
    this.actions,
    @required this.columns,
    this.nextPage,
    this.previousPage,
    this.firstPage,
    this.total,
    this.onTap,
    this.onTapFirstPage,
    this.onTapForward,
    this.onTapBackward,
    this.sortColumnIndex = 0,
    this.sortAscending = true,
    this.onSelectAll,
    this.from,
    this.to,
    this.dataRowHeight = kMinInteractiveDimension,
    this.headingRowHeight = 40.0,
    this.horizontalMargin = 24.0,
    this.columnSpacing = 56.0,
    this.showCheckboxColumn = true,
    this.initialFirstRowIndex = 0,
    this.onPageChanged,
    this.rowsPerPage = defaultRowsPerPage,
    this.availableRowsPerPage = const <int>[
      defaultRowsPerPage,
      defaultRowsPerPage * 2,
      defaultRowsPerPage * 5,
      defaultRowsPerPage * 10
    ],
    this.onRowsPerPageChanged,
    this.footerStyle,
    this.dropdownStyle,
    this.previousNextStyle,
    this.footer = true,
    @required this.source,
  })  : assert(actions == null || (actions != null)),
        assert(columns != null),
        assert(columns!.isNotEmpty),
        assert(sortColumnIndex == null ||
            (sortColumnIndex >= 0 && sortColumnIndex < columns!.length)),
        assert(sortAscending != null),
        assert(dataRowHeight != null),
        assert(headingRowHeight != null),
        assert(horizontalMargin != null),
        assert(columnSpacing != null),
        assert(showCheckboxColumn != null),
        assert(rowsPerPage != null),
        assert(rowsPerPage! > 0),
        assert(() {
          if (onRowsPerPageChanged != null) {
            assert(availableRowsPerPage != null &&
                availableRowsPerPage.contains(rowsPerPage));
          }
          return true;
        }()),
        assert(source != null),
        super(key: key);

  @override
  PaginatedDataTableCustomState createState() =>
      PaginatedDataTableCustomState();
}

class PaginatedDataTableCustomState extends State<PaginatedDataTableCustom> {
  int? _firstRowIndex;
  int? _rowCount;
  bool? _rowCountApproximate;
  final Map<int, DataRow> _rows = <int, DataRow>{};

  @override
  void initState() {
    super.initState();
    _firstRowIndex = PageStorage.of(context).readState(context) ??
        widget.initialFirstRowIndex ??
        0;
    widget.source?.addListener(_handleDataSourceChanged);
    _handleDataSourceChanged();
  }

  @override
  void didUpdateWidget(PaginatedDataTableCustom oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.source != widget.source) {
      oldWidget.source?.removeListener(_handleDataSourceChanged);
      widget.source?.addListener(_handleDataSourceChanged);
      _handleDataSourceChanged();
    }
  }

  @override
  void dispose() {
    widget.source?.removeListener(_handleDataSourceChanged);
    super.dispose();
  }

  void _handleDataSourceChanged() {
    setState(() {
      _rowCount = widget.source?.rowCount;
      _rowCountApproximate = widget.source?.isRowCountApproximate;
      _rows.clear();
    });
  }

  /// Ensures that the given row is visible.
  void pageTo(int rowIndex) {
    final int oldFirstRowIndex = _firstRowIndex!;
    setState(() {
      final int rowsPerPage = widget.rowsPerPage!;
      _firstRowIndex = (rowIndex ~/ rowsPerPage) * rowsPerPage;
    });
    if ((widget.onPageChanged != null) &&
        (oldFirstRowIndex != _firstRowIndex)) {
      widget.onPageChanged!(_firstRowIndex!);
    }
  }

  DataRow _getBlankRowFor(int index) {
    return DataRow.byIndex(
      index: index,
      cells: widget.columns!
          .map<DataCell>((DataColumn column) => DataCell.empty)
          .toList(),
    );
  }

  DataRow _getProgressIndicatorRowFor(int index) {
    bool haveProgressIndicator = false;
    final List<DataCell> cells =
        widget.columns!.map<DataCell>((DataColumn column) {
      if (!column.numeric) {
        haveProgressIndicator = true;
        return DataCell(LoaderClass());
      }
      return DataCell.empty;
    }).toList();
    if (!haveProgressIndicator) {
      haveProgressIndicator = true;
      cells[0] = DataCell(LoaderClass());
    }
    return DataRow.byIndex(
      index: index,
      cells: cells,
    );
  }

  List<DataRow> _getRows(int firstRowIndex, int rowsPerPage) {
    final List<DataRow> result = <DataRow>[];
    final int nextPageFirstRowIndex = firstRowIndex + rowsPerPage;
    bool haveProgressIndicator = false;
    for (int index = firstRowIndex; index < nextPageFirstRowIndex; index += 1) {
      DataRow? row;
      if (index < _rowCount! || _rowCountApproximate!) {
        row = _rows.putIfAbsent(index, () => widget.source!.getRow(index)!);
        if (!haveProgressIndicator) {
          row ??= _getProgressIndicatorRowFor(index);
          haveProgressIndicator = true;
        }
      }
      row ??= _getBlankRowFor(index);
      result.add(row);
    }
    return result;
  }

  void _handlePrevious() {
    pageTo(math.max(_firstRowIndex! - widget.rowsPerPage!, 0));
  }

  void _handleNext() {
    pageTo(_firstRowIndex! + widget.rowsPerPage!);
  }

  final GlobalKey _tableKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);

    // FOOTER
    final TextStyle footerTextStyle =
        widget.footerStyle ?? TextStyle(color: Colors.grey, fontSize: 12);
    final DropdownStyle footerDropdownStyle = widget.dropdownStyle ??
        DropdownStyle(
          textColor: Colors.grey[900],
          triggerIconColor: Colors.grey,
          dropdownCanvasColor: Colors.white,
          textSize: 14.0,
          triggerIconSize: 24.0,
        );

    final PreviousNextStyle previousNextStyle = widget.previousNextStyle ??
        PreviousNextStyle(
          iconColor: Colors.grey,
          iconSize: 24.0,
        );
    final List<Widget> footerWidgets = <Widget>[];
    final List<Widget> availableRowsPerPage = widget.availableRowsPerPage!
        .where(
            (int value) => value <= _rowCount! || value == widget.rowsPerPage)
        .map<DropdownMenuItem<int>>((int value) {
      return DropdownMenuItem<int>(
        value: value,
        child: Text('$value'),
      );
    }).toList();

    footerWidgets.addAll(<Widget>[
      DefaultTextStyle(
        style: footerTextStyle,
        child: Text("Rows :"),
      ),
      SizedBox(
        width: 10,
      ),
      ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 64.0),
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              dropdownColor: footerDropdownStyle.dropdownCanvasColor,
              items: availableRowsPerPage.cast<DropdownMenuItem<int>>(),
              value: widget.rowsPerPage,
              onChanged: widget.onRowsPerPageChanged,
              style: TextStyle(
                color: footerDropdownStyle.textColor,
                fontSize: footerDropdownStyle.textSize,
              ),
              iconSize: footerDropdownStyle.triggerIconSize!,
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: footerDropdownStyle.triggerIconColor,
              ),
            ),
          ),
        ),
      ),
    ]);

    footerWidgets.addAll(<Widget>[
      SizedBox(
        width: 10.0,
      ),
      DefaultTextStyle(
        style: footerTextStyle,
        child: Text(
          localizations.pageRowsInfoTitle(
            widget.from ?? _firstRowIndex! + 1,
            widget.to ?? _firstRowIndex! + widget.rowsPerPage!,
            widget.total ?? _rowCount!,
            _rowCountApproximate!,
          ),
        ),
      ),
      SizedBox(width: 10.0),
      IconButton(
        icon: Icon(
          Icons.arrow_back_sharp,
          color: widget.previousPage == null
              ? previousNextStyle.iconColor?.withOpacity(0.5)
              : previousNextStyle.iconColor,
          size: previousNextStyle.iconSize,
        ),
        padding: EdgeInsets.zero,
        tooltip: localizations.previousPageTooltip,
        onPressed: widget.onTapFirstPage,
        //     (){
        //   if(widget.previousPage != null){
        //     final provider = Provider.of<ApisProvider>(context, listen: false);
        //     provider.getBonusData(context,url: widget.firstPage);
        //   }
        // },
      ),
      IconButton(
        icon: Icon(
          Icons.chevron_left,
          color: widget.previousPage == null
              ? previousNextStyle.iconColor?.withOpacity(0.5)
              : previousNextStyle.iconColor,
          size: previousNextStyle.iconSize,
        ),
        padding: EdgeInsets.zero,
        tooltip: localizations.previousPageTooltip,
        onPressed: widget.onTapBackward,
        // onPressed: (){
        //   if(widget.previousPage != null){
        //     final provider = Provider.of<ApisProvider>(context, listen: false);
        //     provider.getBonusData(context,url: widget.previousPage);
        //   }
        // },
      ),
      SizedBox(width: 10.0),
      IconButton(
        icon: Icon(
          Icons.chevron_right,
          color: widget.nextPage == null
              ? previousNextStyle.iconColor?.withOpacity(0.5)
              : previousNextStyle.iconColor,
          size: previousNextStyle.iconSize,
        ),
        padding: EdgeInsets.zero,
        tooltip: localizations.nextPageTooltip,
        onPressed: widget.onTapForward,
        // onPressed: (){
        //   if(widget.nextPage != null){
        //     final provider = Provider.of<ApisProvider>(context, listen: false);
        //     provider.getBonusData(context,url: widget.nextPage);
        //   }
        // },
      ),
      Container(width: 10.0),
    ]);

    // TABLE
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: DataTable(
                  border: TableBorder.all(
                    width: 1.0,
                    color:
                        // _firstRowIndex == 0
                        //     ? DynamicColors.primaryColorRed
                        //     :
                        DynamicColors.accentColor,
                  ),
                  headingRowColor: MaterialStateProperty.resolveWith((states) {
                    return DynamicColors.accentColor.withOpacity(0.3);
                  }),
                  headingTextStyle: poppinsBold(
                      color: DynamicColors.primaryColorRed, fontSize: 15),
                  key: _tableKey,
                  dataTextStyle: poppinsRegular(
                      color: DynamicColors.textColor, fontSize: 15),
                  columns: widget.columns!,
                  sortColumnIndex: widget.sortColumnIndex,
                  sortAscending: widget.sortAscending!,
                  dataRowMinHeight: widget.dataRowHeight,
                  dataRowMaxHeight: widget.dataRowHeight!*1.5,
                  onSelectAll: widget.onSelectAll,
                  // dataRowHeight: widget.dataRowHeight,
                  headingRowHeight: widget.headingRowHeight,
                  horizontalMargin: widget.horizontalMargin,
                  columnSpacing: widget.columnSpacing,
                  showCheckboxColumn: widget.showCheckboxColumn!,
                  rows: _getRows(_firstRowIndex!, widget.rowsPerPage!),
                ),
              ),
            ),
            widget.footer == true && widget.isDashboardFooter == false
                ? SizedBox(
                    //Utils.isTableView == true
                    height: 56.0,

                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      child: Row(
                        children: footerWidgets,
                      ),
                    ),
                  )
                : widget.footer == true && widget.isDashboardFooter == true
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SizedBox(
                          //Utils.isTableView == true
                          height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: widget.onTap,
                                child: Text(
                                  "Show More",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    : Container(),
          ],
        );
      },
    );
  }
}

class DataSource extends DataTableSource {
  final list, cellsList;
  DataSource(this.context, this.list, this.cellsList);

  final BuildContext context;

  final int _selectedCount = 0;

  @override
  // ignore: missing_return
  DataRow getRow(int index) {
    assert(index >= 0);

    if (list != 0) {
      if (cellsList.length != index) {
        if (index % 2 == 0) {
          return DataRow(
            color: MaterialStateProperty.all(Theme.of(context).primaryColor),
            cells: [
              for (int j = 0; j < cellsList[index].cells.length; j++)
                cellsList[index].cells[j],
            ],
          );
        } else {
          return DataRow(
            color:
                MaterialStateProperty.all(Theme.of(context).bottomAppBarColor),
            cells: [
              for (int j = 0; j < cellsList[index].cells.length; j++)
                cellsList[index].cells[j],
            ],
          );
        }
      }
    } else {
      return DataRow(
        color: MaterialStateProperty.all(Theme.of(context).primaryColor),
        cells: [],
      );
    }
    return DataRow(
      color: MaterialStateProperty.all(Theme.of(context).primaryColor),
      cells: [],
    );
  }

  @override
  int get rowCount => cellsList.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}
