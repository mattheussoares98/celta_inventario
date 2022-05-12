import 'package:celta_inventario/pages/product_page/product_provider.dart';
import 'package:celta_inventario/provider/quantity_provider.dart';
import 'package:celta_inventario/utils/show_error_message.dart';
import 'package:celta_inventario/utils/user_identity.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class AddQuantityController {
  addQuantity({
    required bool isIndividual,
    required BuildContext context,
    required int countingCode,
    required dynamic
        quantity, //coloquei como dynamic porque pode ser um controller ou somente o valor direto, como no caso de quando está inserindo os produtos individualmente que precisa inserir direto a quantidade "1"
    required bool isSubtract,
    void Function()? alterFocusToConsultedProduct,
  }) async {
    QuantityProvider quantityProvider = Provider.of(context, listen: false);
    ProductProvider productProvider = Provider.of(context, listen: false);

    try {
      await quantityProvider.entryQuantity(
        countingCode: countingCode,
        productPackingCode: productProvider.products[0].codigoInternoProEmb,
        quantity: isIndividual ? '1' : quantity.text,
        userIdentity: UserIdentity.identity,
        isSubtract: isSubtract,
      );
    } catch (e) {
      e;
    }
    if (quantityProvider.errorMessage != '') {
      ShowErrorMessage().showErrorMessage(
        error: quantityProvider.errorMessage,
        context: context,
      );
      alterFocusToConsultedProduct!();
      return;
    }

    if (quantityProvider.isConfirmedQuantity) {
      var quantityInvContProEmb =
          productProvider.products[0].quantidadeInvContProEmb;

      //se estiver como nulo, é porque nenhuma informação foi
      //adicionada ainda. Por isso precisa deixar o valor como '0'
      if (quantityInvContProEmb.toString() == 'null') {
        quantityInvContProEmb = int.tryParse('0');
      }

      if (isIndividual) {
        quantityInvContProEmb = quantityInvContProEmb + double.tryParse('1');
        return;
      }

      if (isSubtract) {
        quantityInvContProEmb = quantityInvContProEmb -
            double.tryParse(quantity.text.replaceAll(RegExp(r','), '.'));
      } else {
        quantityInvContProEmb = quantityInvContProEmb +
            double.tryParse(quantity.text.replaceAll(RegExp(r','), '.'));
      }
    }

    quantity.clear();

    if (!isIndividual) {
      alterFocusToConsultedProduct!();
    }
  }
}
