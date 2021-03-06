$(function() {
	// Sort the left navigation alphabetically.
	var $links = $('.area-link'),
		items = [];
	
	$links.each(function(index) {
		items[index] = {
			elem: $(this),
			text: $(this).text(),
			href: $(this).attr('href'),
			klass: $(this).attr('class'),
		}
	});

	items = items.sort(function(a, b) {
		if (a.text < b.text) {
			return -1;
		} else if (a.text > b.text) {
			return +1;
		} else {
			return 0;
		}
	});

	$links.each(function(index) {
		$(this).text(items[index].text);
		$(this).attr('href', items[index].href);
		$(this).attr('class', items[index].klass);
	});

	// Setup search.
	function onSelectItem(item, element) {
		document.location.href = item.value;
	}

	$('#search').autocomplete({
		source: search,
		onSelectItem: onSelectItem,
		highlightClass: 'text-success',
		maximumItems: 15,
		threshold: 2,
		treshold: 2,
	});
});