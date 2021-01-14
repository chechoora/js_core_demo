(function () {
    function getCakeEaters() {
        let pieces = cake.pieces;
        flutterPrint('getCakeEaters Start: ' + pieces);
        if (pieces < guests.length) {
            throw "Too many pieces";
        }

        let whoCanEatCake = [];
        for (let i = 0; i < guests.length; i++) {
            flutterPrint('getCakeEaters i: ' + i);
            let currentGuest = guests[i];
            if (canEatCake(cake, currentGuest)) {
                whoCanEatCake.push(currentGuest);
            }
        }
        return whoCanEatCake;
    }

    function canEatCake(cake, guest) {
        if ((guest.glutenAllergic && cake.hasGluten) ||
            (!guest.favoriteToppings.includes(cake.topping))) {
            flutterPrint('canEatCake no: ' + guest.name);
            return false;
        }
        flutterPrint('canEatCake yes: ' + guest.name);
        return true;
    }

    flutterPrint('Validation start.');

    let validGuests = getCakeEaters();

    if (validGuests.length == 0) {
        flutterPrint('No valid guests');
        throw "Nobody can eat the cake";
    }

    flutterPrint('Validation function done.');
    return validGuests;
})();