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
		$(this).html('<a class="' + items[index].klass + '" href="'
			+ items[index].href + '">' + items[index].text + '</a>'
		);
	});

	console.log(items);
});