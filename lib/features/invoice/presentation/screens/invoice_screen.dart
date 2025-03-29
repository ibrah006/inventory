import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart' as mt;
import 'package:inventory/config/routes.dart';
import 'package:inventory/core/providers/invoice_provider.dart';
import 'package:inventory/core/providers/stock_provider.dart';
import 'package:inventory/core/models/invoice.dart';
import 'package:inventory/features/invoice/data/invoice_item.dart';
import 'package:inventory/features/invoice/presentation/widgets/reusable_card.dart';
import 'package:inventory/presentation/providers/party_provider.dart';
import 'package:inventory/presentation/stream_state/stream_state_manager.dart';
import 'package:inventory/presentation/widgets/dialogs.dart';
import 'package:inventory/presentation/widgets/tables/custom_table/column_item.dart';
import 'package:inventory/presentation/widgets/tables/custom_table/custom_table.dart';
import 'package:inventory/presentation/widgets/tables/row_info/row_info_regular.dart';
import 'package:provider/provider.dart';
import 'package:super_context_menu/super_context_menu.dart';

class InvoiceScreen extends StatefulWidget {
  InvoiceScreen(this.invoice);

  final Invoice invoice;

  /// The minimum screen height for notes / terms field to be on the left
  static const MIN_SCREEN_HEIGHT_NOTES_LEFT = 580;

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  late final Invoice invoice;

  final FlyoutController issueDateMenuController = FlyoutController();

  TextStyle get headerStyle => FluentTheme.of(context)
      .typography
      .title!
      .copyWith(fontWeight: FontWeight.w400);

  InvoiceItem newInvoiceRow = InvoiceItem();

  final StreamStateManager newInvoiceRowAmountFieldState = StreamStateManager();

  // List<RowInfo> invoiceRows = [
  //   // RowInfo(rowCells: ["Sample", "22", "\$2.22", "\$${(22 * 2.22).toString()}"])
  // ];

  bool editTax = false;

  void updatenewInvoiceRowAmountTextBox() {
    newInvoiceRow.amount = newInvoiceRow.cost * newInvoiceRow.quantity;
    newInvoiceRowAmountFieldState.updateState();
  }

  Widget get notesField => InfoLabel(
        label: "Notes / Terms",
        child: TextBox(
          controller: invoice.notesController,
          placeholder: "Enter note or terms of service",
          maxLines: 4,
        ),
      );

  String get deliveryDueDateTextBoxLabel =>
      "Due Date${invoice.isPurchaseInvoice ? " (Expected)" : ""}";

  // Show "vendor" for purchase and "customer" for sales invoice
  String get partyName => invoice.isPurchaseInvoice ? "Vendor" : "Customer";

  @override
  Widget build(BuildContext context) {
    final stockItems = Provider.of<StockProvider>(context).getStock();

    final partyProvider = Provider.of<PartyProvider>(context);

    final screenHeight = MediaQuery.of(context).size.height;

    final isNotesFieldOnLeft =
        screenHeight > InvoiceScreen.MIN_SCREEN_HEIGHT_NOTES_LEFT;

    return Provider<InvoiceProvider>(
      create: (context) => InvoiceProvider(invoice.type),
      builder: (context, child) {
        // passing in the context is crucial here as it will be used to determine the type of invoice screen (purchase/sales) the user's at through InvoiceProvider
        final parties = partyProvider.parties(context);

        debugPrint("parties: $parties");

        return FluentTheme(
          data: FluentThemeData(scaffoldBackgroundColor: Color(0xFFeff3f6)),
          child: ScaffoldPage(
            header: PageHeader(
              leading: Padding(
                padding: const EdgeInsets.only(left: 25, right: 15),
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.white),
                        padding: WidgetStatePropertyAll(EdgeInsets.all(10.0))),
                    icon: Icon(FluentIcons.back)),
              ),
              commandBar: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FilledButton(
                    onPressed: saveInvoiceEntry,
                    child: Row(
                      children: [
                        Icon(FluentIcons.save),
                        SizedBox(width: 5),
                        Text("Save Invoice", style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
              title: Text(
                "Create ${invoice.type.name.uppercaseFirst()} Invoice",
                style: headerStyle,
              ),
            ),
            content: SingleChildScrollView(
              padding: EdgeInsets.only(top: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: ReusableCard(
                      disableShadow: true,
                      margin: EdgeInsets.only(left: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Invoice",
                            style: headerStyle,
                          ),
                          const SizedBox(height: 16),

                          // Invoice Details
                          Row(
                            children: [
                              Expanded(
                                child: InfoLabel(
                                  label: "Invoice Number",
                                  child: TextBox(
                                    controller: invoice.invoiceNumberController,
                                    placeholder: "Enter Invoice Number",
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: InfoLabel(
                                  label: "P.O/S.O Number",
                                  child: TextBox(
                                    controller: invoice.poSoNumberController,
                                    placeholder: "Enter P.O/S.O Number",
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          InfoLabel(
                            label: "Project Detail",
                            child: TextBox(
                              placeholder:
                                  "Summary (e.g., project name, description)",
                              maxLines: 2,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Items Table
                          CustomTable(
                            columnItems: [
                              ColumnItem(title: "", flex: .4),
                              ColumnItem(title: "Items", flex: 3),
                              ColumnItem(title: "Qty", flex: .9),
                              ColumnItem(title: "Cost", flex: 1.2),
                              ColumnItem(title: "Amount", flex: 1.5)
                            ],
                            // dataCellItems: {},
                            data: invoice.items
                                .map((invoiceItem) => invoiceItem.toRowInfo())
                                .toList(),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                flex: 48,
                                child: AutoSuggestBox(
                                  // TODO; pass in the stock items
                                  controller: newInvoiceRow.itemDescController,
                                  items: stockItems
                                      .map<AutoSuggestBoxItem>((stockItem) {
                                    return AutoSuggestBoxItem(
                                        value: stockItem.product.id,
                                        onSelected: () {
                                          setState(() {
                                            newInvoiceRow.onNewIdSelected(
                                                stockItem.product);
                                          });
                                        },
                                        label:
                                            "${stockItem.product.id} ${stockItem.product.desc}");
                                  }).toList(),
                                  placeholder: "Enter item",
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 12,
                                child: TextBox(
                                  controller: newInvoiceRow.quantityController,
                                  placeholder: "Qty",
                                  onChanged: (value) {
                                    updatenewInvoiceRowAmountTextBox();
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 16,
                                child: TextBox(
                                  controller: newInvoiceRow.costController,
                                  placeholder: "Cost",
                                  onChanged: (value) =>
                                      updatenewInvoiceRowAmountTextBox(),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 22,
                                child: StreamBuilder(
                                    stream:
                                        newInvoiceRowAmountFieldState.stream,
                                    builder: (context, snapshot) {
                                      return TextBox(
                                        controller:
                                            newInvoiceRow.amountController,
                                        enabled: false,
                                        placeholder: "Amount",
                                      );
                                    }),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Button(
                            style: ButtonStyle(
                                shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                        side: BorderSide.none)),
                                foregroundColor:
                                    WidgetStatePropertyAll(Colors.blue)),
                            onPressed: addInvoiceItem,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  String.fromCharCode(
                                      FluentIcons.add.codePoint),
                                  style: TextStyle(
                                    inherit: true,
                                    fontSize: 11.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: FluentIcons.add.fontFamily,
                                    package: FluentIcons.add.fontPackage,
                                  ),
                                ),
                                SizedBox(width: 6),
                                const Text("Add Item"),
                              ],
                            ),
                          ),

                          const SizedBox(height: 22),

                          if (isNotesFieldOnLeft) notesField
                        ],
                      ),
                    ),
                  ),

                  // Payment Section
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        ReusableCard(
                            margin: EdgeInsets.symmetric(horizontal: 10.0),
                            disableShadow: true,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Delivery Details",
                                  style: FluentTheme.of(context)
                                      .typography
                                      .subtitle,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                LayoutBuilder(builder: (context, constraints) {
                                  final isSmallWidth =
                                      constraints.maxWidth < 270;

                                  final children = [
                                    InfoLabel(
                                      label: "Status",
                                      child: ComboBox<String>(
                                        value: invoice.delivery.status,
                                        items: [
                                          "Done",
                                          "Ongoing",
                                          "Yet to start"
                                        ].map<ComboBoxItem<String>>((e) {
                                          return ComboBoxItem<String>(
                                            child: Text(e),
                                            value: e,
                                          );
                                        }).toList(),
                                        onChanged: (status) {
                                          setState(() {
                                            invoice.delivery.status = status!;
                                          });
                                        },
                                        // : (color) {
                                        //     setState(() => selectedCat = color);
                                        //   },
                                        placeholder:
                                            const Text('Select status'),
                                      ),
                                    ),
                                    InfoLabel(
                                      label: deliveryDueDateTextBoxLabel,
                                      child: TextBox(
                                        controller:
                                            invoice.delivery.dueDateController,
                                        placeholder: "DD/MM/YYYY",
                                        suffix: Icon(FluentIcons.calendar),
                                      ),
                                    ),
                                  ];

                                  return isSmallWidth
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: children)
                                      : Row(
                                          children: children
                                              .map((child) =>
                                                  Expanded(child: child))
                                              .toList(),
                                        );
                                }),
                              ],
                            )),
                        SizedBox(height: 10),
                        ReusableCard(
                          disableShadow: true,
                          margin: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Invoice Information & Payment",
                                style:
                                    FluentTheme.of(context).typography.subtitle,
                              ),
                              const SizedBox(height: 16),

                              Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  InfoLabel(
                                    label: "Send To",
                                    child: AutoSuggestBox<String>(
                                      placeholder: partyName,
                                      controller: invoice.party.nameController,
                                      items: List.generate(parties.length,
                                          (index) {
                                        return AutoSuggestBoxItem(
                                            value: parties[index].id,
                                            label: parties[index].name);
                                      }),
                                      onOverlayVisibilityChanged:
                                          (focussed) async {
                                        if (!focussed) {
                                          validateVendor();
                                        }
                                      },
                                    ),
                                  ),
                                  if (invoice.party.showSuccessfullyAdded)
                                    Container(
                                      padding: EdgeInsets.all(2.5),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.successPrimaryColor),
                                      child: Icon(
                                        FluentIcons.check_mark,
                                        color: Colors.white,
                                        size: 12,
                                      ),
                                    )
                                ],
                              ),
                              SizedBox(height: 5.0),
                              if (invoice.party.showIdTextBox)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: InfoLabel(
                                          labelStyle: FluentTheme.of(context)
                                              .typography
                                              .caption!
                                              .copyWith(
                                                  color: invoice.party
                                                              .errorMessage !=
                                                          null
                                                      ? Colors.red
                                                      : null),
                                          label: invoice.party.errorMessage ??
                                              "${invoice.isPurchaseInvoice ? "Vendor" : "Customer"} ID",
                                          child: SizedBox(
                                            height: 25.0,
                                            child: TextBox(
                                              style: FluentTheme.of(context)
                                                  .typography
                                                  .caption!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w500),
                                              onSubmitted: (value) => invoice
                                                  .party
                                                  .validateIdTextField(context),
                                              padding: EdgeInsets.all(5.0),
                                              controller:
                                                  invoice.party.idController,
                                              focusNode:
                                                  invoice.party.idFocusNode,
                                            ),
                                          )),
                                    ),
                                    SizedBox(width: 5.0),
                                    FilledButton(
                                      onPressed: () {
                                        invoice.party
                                            .validateIdTextField(context);
                                      },
                                      style: ButtonStyle(
                                          padding: WidgetStatePropertyAll(
                                              EdgeInsets.symmetric(
                                                  horizontal: 9.0,
                                                  vertical: 6.5))),
                                      child: Row(
                                        children: [
                                          Icon(FluentIcons.check_mark),
                                          SizedBox(width: 5),
                                          Text("Confirm",
                                              style: TextStyle(fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                              const SizedBox(height: 16),

                              // Only show Payment method dropdown for Purchase Invoice
                              if (invoice.isPurchaseInvoice) ...[
                                InfoLabel(
                                  label: "Payment Method",
                                  child: ComboBox<String>(
                                    isExpanded: true,
                                    items: [
                                      ComboBoxItem(
                                          child: Text("Method 1"), value: "1"),
                                      ComboBoxItem(
                                          child: Text("Method 2"), value: "2"),
                                    ],
                                    onChanged: (value) {},
                                  ),
                                ),
                                const SizedBox(height: 16)
                              ],

                              Row(
                                children: [
                                  Expanded(
                                    child: InfoLabel(
                                      label: "Issued Date",
                                      child: TextBox(
                                        controller: invoice.issueDateController,
                                        placeholder: "DD/MM/YYYY",
                                        suffix: FlyoutTarget(
                                          controller: issueDateMenuController,
                                          child: IconButton(
                                              style: ButtonStyle(
                                                  padding:
                                                      WidgetStatePropertyAll(
                                                          EdgeInsets.zero)),
                                              onPressed: () {
                                                issueDateMenuController
                                                    .showFlyout(
                                                  autoModeConfiguration:
                                                      FlyoutAutoConfiguration(
                                                    preferredMode:
                                                        FlyoutPlacementMode
                                                            .topCenter,
                                                  ),
                                                  barrierDismissible: true,
                                                  dismissOnPointerMoveAway:
                                                      false,
                                                  dismissWithEsc: true,
                                                  builder: (context) {
                                                    return MenuFlyout(items: [
                                                      MenuFlyoutItem(
                                                          leading: const Icon(
                                                              FluentIcons
                                                                  .goto_today),
                                                          text: const Text(
                                                              'Today'),
                                                          onPressed: () {
                                                            invoice
                                                                .issueDateController
                                                                .text = DateFormat(
                                                                    'dd/MM/yyyy')
                                                                .format(DateTime
                                                                    .now());
                                                            ;
                                                            Flyout.of(context)
                                                                .close();
                                                          }),
                                                    ]);
                                                  },
                                                );
                                              },
                                              icon: Icon(FluentIcons.calendar,
                                                  size: 17)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),

                                  // Only show the payment due date text box for Purchase Invoice
                                  if (invoice.isPurchaseInvoice)
                                    Expanded(
                                      child: InfoLabel(
                                        label: "Due Date",
                                        child: TextBox(
                                          controller: invoice.dueDateController,
                                          placeholder: "DD/MM/YYYY",
                                          suffix: Icon(FluentIcons.calendar),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Subtotal, Tax, and Total
                              Row(
                                children: [
                                  Text(
                                    "Subtotal",
                                    style: FluentTheme.of(context)
                                        .typography
                                        .body!
                                        .copyWith(color: Colors.grey[110]),
                                  ),
                                  Expanded(child: SizedBox()),
                                  Text(
                                    "US\$ ",
                                    style: FluentTheme.of(context)
                                        .typography
                                        .bodyStrong!
                                        .copyWith(color: Colors.grey[60]),
                                  ),
                                  Text(
                                    invoice.subTotal.toStringAsFixed(2),
                                    style: FluentTheme.of(context)
                                        .typography
                                        .bodyStrong!
                                        .copyWith(color: Colors.grey[150]),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              ContextMenuWidget(
                                menuProvider: (_) {
                                  return Menu(
                                    children: [
                                      MenuAction(
                                          title: 'Edit',
                                          callback: () {
                                            setState(() {
                                              editTax = true;
                                            });
                                          }),
                                      MenuAction(
                                          title: 'Menu Item 3',
                                          callback: () {}),
                                      MenuSeparator(),
                                      Menu(title: 'Submenu', children: [
                                        MenuAction(
                                            title: 'Submenu Item 1',
                                            callback: () {}),
                                        MenuAction(
                                            title: 'Submenu Item 2',
                                            callback: () {}),
                                        Menu(
                                            title: 'Nested Submenu',
                                            children: [
                                              MenuAction(
                                                  title: 'Submenu Item 1',
                                                  callback: () {}),
                                              MenuAction(
                                                  title: 'Submenu Item 2',
                                                  callback: () {}),
                                            ]),
                                      ]),
                                    ],
                                  );
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "Tax",
                                      style: FluentTheme.of(context)
                                          .typography
                                          .body!
                                          .copyWith(color: Colors.grey[110]),
                                    ),
                                    Expanded(
                                        child: (editTax)
                                            ? mt.Material(
                                                color: Colors.transparent,
                                                child: mt.TextField(
                                                  cursorHeight: 13,
                                                  textAlign: TextAlign.right,
                                                  controller:
                                                      invoice.taxController,
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                  decoration: mt.InputDecoration(
                                                      hintText:
                                                          "Type in a Tax amount/percentage(%)",
                                                      hintStyle: FluentTheme.of(
                                                              context)
                                                          .typography
                                                          .caption!
                                                          .copyWith(
                                                              color: Colors
                                                                  .grey[90],
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300),
                                                      contentPadding: EdgeInsets
                                                          .zero,
                                                      border:
                                                          mt.OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide
                                                                      .none)),
                                                  onEditingComplete: () {
                                                    final taxText = invoice
                                                        .taxController.text;
                                                    final isTaxPercentage =
                                                        taxText.contains("%");

                                                    if (isTaxPercentage) {
                                                      final taxPercentage =
                                                          double.parse(taxText);
                                                      final taxAmount =
                                                          (invoice.subTotal /
                                                                  100) *
                                                              taxPercentage;
                                                      invoice.taxAmount =
                                                          taxAmount;
                                                    }

                                                    setState(() {
                                                      editTax = false;
                                                    });
                                                  },
                                                ),
                                              )
                                            : Text(
                                                invoice.taxAmount > 0
                                                    ? invoice.taxAmount
                                                        .toStringAsFixed(3)
                                                    : "-",
                                                textAlign: TextAlign.right,
                                                style: FluentTheme.of(context)
                                                    .typography
                                                    .body))
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14.0),
                              Button(
                                style: ButtonStyle(
                                    padding: WidgetStatePropertyAll(
                                        EdgeInsets.only(
                                            left: 2.0, right: 12.0)),
                                    shape: WidgetStatePropertyAll(
                                        RoundedRectangleBorder(
                                            side: BorderSide.none))),
                                onPressed: () {},
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(FluentIcons.add_bookmark,
                                        color: Colors.blue),
                                    SizedBox(width: 10.0),
                                    Text("Add Discount",
                                        style: FluentTheme.of(context)
                                            .typography
                                            .bodyStrong!
                                            .copyWith(
                                                fontSize: 12.5,
                                                color: Colors.blue)),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 21.0),
                              Row(
                                children: [
                                  Text(
                                    "Total",
                                    style: FluentTheme.of(context)
                                        .typography
                                        .body!
                                        .copyWith(color: Colors.grey[110]),
                                  ),
                                  Expanded(child: SizedBox()),
                                  Text(
                                    "US\$ ",
                                    style: FluentTheme.of(context)
                                        .typography
                                        .bodyStrong!
                                        .copyWith(color: Colors.grey[110]),
                                  ),
                                  Text(
                                    invoice.totalAmount.toStringAsFixed(2),
                                    style: FluentTheme.of(context)
                                        .typography
                                        .body!
                                        .copyWith(color: Colors.grey[110]),
                                  ),
                                ],
                              ),

                              // notes / terms alternative position
                              if (!isNotesFieldOnLeft) ...[
                                SizedBox(height: 15),
                                notesField
                              ]
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    invoice = widget.invoice;

    if (invoice.initialItemDesc != null) {
      newInvoiceRow.itemDescController.text = invoice.initialItemDesc!;
    }
  }

  void validateVendor() async {
    final vendorName = invoice.party.nameController.text.trim();

    if (vendorName.isEmpty) {
      invoice.party.id = "";
      return;
    }

    final partyProvider = Provider.of<PartyProvider>(context, listen: false);

    final vendorExists = partyProvider.partyExists(name: vendorName);

    print("this vendor exists: $vendorExists");

    if (vendorExists) {
      // set the vendor in voice
      // TODO: MAKE IT SO THAT USER CAN CONTROL THE VENDOR ID
      // invoice.vendor = Vendor(context, id: );
    } else {
      invoice.party.id = "";
      final action = await Dialogs.vendorNotFoundDialog(context,
          vendor: vendorName, isVendor: invoice.isPurchaseInvoice);

      /// action can be "cancel" or "proceed"
      if (action == "proceed") {
        // vendorsProvider.add(Vendor.create(id: , name: vendorName));

        setState(() {
          invoice.party.resetFieldsNewVendor();
          //TODO: change focus using focus node to vendor id text box
        });
      } else {
        invoice.party.nameController.clear();
      }
    }
  }

  void addInvoiceItem() async {
    final AddInvoiceItemFeedback validateNewInvoiceRow =
        newInvoiceRow.canValidateFields(context);

    bool canAdd = false;

    print(validateNewInvoiceRow);

    switch (validateNewInvoiceRow) {
      case AddInvoiceItemFeedback.itemError:
        Dialogs.itemNotFoundDialog(context, itemName: newInvoiceRow.itemDesc);
      case AddInvoiceItemFeedback.quantityError:
        Dialogs.quantityErrorDialog(context,
            body:
                "Quantity cannot be less than 1. Please add more quantity to proceed.");
      case AddInvoiceItemFeedback.warning:
        canAdd = (await Dialogs.costWarning(context)) == "yes";
      default:
        canAdd = true;
    }

    print('can add: $canAdd');

    if (canAdd) {
      setState(() {
        // invoiceRows.add();

        invoice.add(InvoiceItem.fromRowInfo(RowInfo(
            rowCells: List.generate(
                4,
                (index) => [
                      newInvoiceRow.itemDescController.text,
                      newInvoiceRow.quantityController.text,
                      newInvoiceRow.costController.text,
                      newInvoiceRow.amountController.text
                    ][index]))));

        invoice.subTotal += invoice.items.last.amount;
      });

      newInvoiceRow.clearTextFields();
    }
  }

  void saveInvoiceEntry() async {
    //TODO: implement this

    // Validate the mandatory fields

    // late final double taxAmount;
    // try {
    //   taxAmount = double.parse(invoice.text.trim());
    // } catch (e) {
    //   taxAmount = 0.0;
    // }

    // get sub-total
    // final subTotal =
    //     RowInfo.computeSummation(rows: invoiceRows, columnIndex: 3);

    print("develiry status: ${invoice.delivery.status}");

    // final formattedToInvoiceItems = invoiceRows.map((rowInfo) {
    //   return InvoiceItem.fromRowInfo(rowInfo);
    // });

    // Invoice invoice = Invoice(
    //     invoiceNumber: invoiceNumberController.text,
    //     vendor: Vendor(name: vendorController.text),
    //     isPurchaseInvoice: true,
    //     poSoNumber: poSoNumberController.text,
    //     project: null,
    //     notes: notesController.text,
    //     paymentMethod: null,
    //     issueDue: isseuDateController.text,
    //     dueDate: dueDateController.text,
    //     taxAmount: taxAmount,
    //     subTotal: subTotal,
    //     items: formattedToInvoiceItems);

    // invoice.delivery = InvoiceDelivery(
    //     dueDate: invoice.deliveryDueDateController.text, status: deliveryStatus);

    final validationFeedbacks =
        invoice.validateFields(isPurchaseInvoice: invoice.isPurchaseInvoice);

    final isValid =
        validationFeedbacks.first == InvoiceValidationFeedback.valid;

    print("isvalid: ${isValid}, validationFeedbacks: ${validationFeedbacks}");

    final isZeroTotal =
        validationFeedbacks.remove(InvoiceValidationFeedback.zeroTotalWarning);

    if (isValid || (isZeroTotal && validationFeedbacks.isEmpty)) {
      if (isZeroTotal) {
        final result = await Dialogs.showZeroTotalInvoiceWarning(context);
        if (result != "yes") {
          // If the user hit cancel then we dont want to add this invoice
          return;
        }
      }

      // Add invoice entry
      Provider.of<StockProvider>(context, listen: false)
          .saveInvoiceEntry(invoice);
      // Add to Database

      // Reset All Fields
      final action = await Dialogs.showSuccessfullyAddInvoice(context);
      if (action == "add another") {
        Navigator.popAndPushNamed(
            context,
            invoice.isPurchaseInvoice
                ? AppRoutes.purchaseInvoice
                : AppRoutes.salesInvoice);
      } else {
        Navigator.pop(context);
      }
    } else {
      await Dialogs.showInvoiceErrors(context,
          validationFeedbacks: validationFeedbacks);
    }
  }
}
