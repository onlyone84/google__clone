const inputSearch = document.getElementById("search");
const search = "https://google.com/search?q=";

function searchGoogle() {
  location.replace(search + inputSearch.value);
}

function sayaBeruntung() {
  location.replace('https://github.com/onlyone84');
}

inputSearch.addEventListener("keypress", function(event) {
  if (event.key === "Enter") {
    searchGoogle();
  }
});
