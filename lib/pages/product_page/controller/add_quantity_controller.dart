import 'package:celta_inventario/pages/product_page/product_provider.dart';
import 'package:celta_inventario/provider/quantity_provider.dart';
import 'package:celta_inventario/utils/show_error_message.dart';
import 'package:celta_inventario/utils/user_identity.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class AddQuantityController {
  _updateLastQuantityAdded({
    required ProductProvider productProvider,
    required bool isSubtract,
    required dynamic quantity,
  }) {
    //se o valor atual for nulo, precisa atribuir o valor de 0 para não dar erro
    //na soma/subtração
    if (productProvider.products[0].quantidadeInvContProEmb == "null") {
      productProvider.products[0].quantidadeInvContProEmb = 0;
    }

    //se for subtração e o resultado da subtração não for menor que 0,
    //vai subtrair o valor atual pelo valor digitado
    if (isSubtract &&
        productProvider.products[0].quantidadeInvContProEmb -
                double.tryParse(quantity.text)! >=
            0) {
      //como não resultou num valor abaixo de 0, pode atualizar o valor da "quantidade contada"
      productProvider.products[0].quantidadeInvContProEmb =
          productProvider.products[0].quantidadeInvContProEmb -
              double.tryParse(quantity.text);
    } else {
      //se não adição, vai somar o valor atual pelo valor digitado
      productProvider.products[0].quantidadeInvContProEmb =
          productProvider.products[0].quantidadeInvContProEmb +
              double.tryParse(quantity.text);
    }
  }

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

      //só vai chegar nessa parte do código se o valor a somar/subtrair digitado
      //pelo usuário for maior que 0. Portanto, pode tentar fazer a soma/subtração
      //do valor digitado pelo usuário
      _updateLastQuantityAdded(
        productProvider: productProvider,
        isSubtract: isSubtract,
        quantity: quantity,
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
