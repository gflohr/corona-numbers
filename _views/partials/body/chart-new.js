(function () {
	'use strict'

	feather.replace()

[% USE q = Qgoda %]
[% USE gtx = Gettext(config.po.textdomain, asset.lingua) %]

	// Graphs
	var ctx = document.getElementById('chartNewCases');
	// eslint-disable-next-line no-unused-vars
	var chartNewCases = new Chart(ctx, {
	  type: 'bar',
	  data: {
		labels: [
			[% FOREACH record IN asset.data %]
				"[% q.strftime(gtx.gettext('%x'), record.timestamp, asset.lingua) %]",
			[% END %]
		],
		datasets: [
			{
				label: "[% gtx.gettext('Confirmed Cases') %]",
				data: [
					[% FOREACH record IN asset.data %]
						[% record.new %],
					[% END %]
				],
				lineTension: 0,
				backgroundColor: '#f04848',
				borderColor: '#f04848',
				borderWidth: 4,
				pointBackgroundColor: '#f04848'
			},
			{
				label: "[% gtx.gettext('14-day Average') %]",
				data: [
					[% FOREACH record IN asset.data %]
						[% record.new14 %],
					[% END %]
				],
				type: 'line'
			},
			{
				label: "[% gtx.gettext('Deaths') %]",
				data: [
					[% FOREACH record IN asset.data %]
						[% record.new_deaths %],
					[% END %]
				],
				type: 'line',
				backgroundColor: '#777777',
				borderColor: '#777777',
				pointBackgroundColor: '#777777'
			},
		]
	  },
	  options: {
		scales: {
		  yAxes: [{
			ticks: {
			  beginAtZero: true
			}
		  }]
		},
		legend: {
		  display: true
		}
	  }
	})
  }())
  