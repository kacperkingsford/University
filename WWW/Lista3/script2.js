var myMap = new Map();

function updateMarka() {
    var markaId = document.getElementById("marka");
    markaId.innerHTML = "";

    myMap.forEach(function(value, marka) {
        var option = document.createElement("option");
        option.value = marka;
        option.text = marka;

        markaId.add(option);
    });
}

function init() {
    myMap.set('', [ '' ]);
    myMap.set('Ford', [ 'Focus', 'Mustang' ]);
    myMap.set('Fiat', [ 'Tipo', 'Doblo' ]);

    updateMarka();
}

function updateModel() {
    var markaId = document.getElementById("marka");
    var selectedMarka = markaId.options[markaId.selectedIndex].value;

    var models = myMap.get(selectedMarka);
    var modelId = document.getElementById("model");
    modelId.innerHTML = "";

    models.forEach(model => {
        var option = document.createElement("option");
        option.value = model;
        option.text = model;

        modelId.add(option);
    });
}

function addElement() {
    var nowaPozycja = document.getElementById("pozycja").value;

    if (nowaPozycja != "") {
        if (document.getElementById("markaRadio").checked) {
            if (typeof myMap.get(nowaPozycja) !== undefined) {
                myMap.set(nowaPozycja, [ '' ]);
                updateMarka();
            }
        }
        else { 
            var markaId = document.getElementById("marka");
            var selectedMarka = markaId.options[markaId.selectedIndex].value;

            if (selectedMarka != "") {
                var models = myMap.get(selectedMarka);

                if (!models.includes(nowaPozycja)) {
                    models.push(nowaPozycja);

                    myMap.set(selectedMarka, models);
                    updateModel();
                }
            }
        }
    }
        
    return false;
}