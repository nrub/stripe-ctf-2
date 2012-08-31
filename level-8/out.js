window.onload = function() {
    console.log('?!');

    run(1, 1.4, 2);
    run(2, 1.9, 3);
    run(3, 2, 4);

};

function run(num, sigma, mean) {
    var filename = 'run' + num + '.json';
    d3.json(filename, function(data) {
		var diffs = [];
		data.forEach(function(row) {
				 var ports = row.map(function(d) { return d.port; });
				 var port = row[0].num;
				 var port_diffs = calculated_port_differences(ports);
				 
				 var port_diff = calculated_port_difference(ports, sigma, num) || mean;

				 if (port_diff > mean) {
				     console.log(num, port, port_diffs.toString());
				 }

				 diffs.push(port_diff);
			     });
		//console.log(diffs);
		graph('#run' + num, diffs);
	    });
}

function calculated_port_differences(arr) {
    var n = arr.length;
    var diffs = [];

    for (var i = 1; i < n; i++) {
	var item = arr[i];
	var last_item = arr[i-1];
	var diff = item - last_item;
	diffs.push(diff);
    }

    return diffs;
}

function calculated_port_difference(arr, sigma, run) {
    var n = arr.length;
    var diffs = [];

    for (var i = 1; i < n; i++) {
	var item = arr[i];
	var last_item = arr[i-1];

	// remove errors when the server refreshed port value
	if (last_item > item) continue;

	var diff = item - last_item;

	var end = false;

	// skip false passwords
	if (diff == 2 && run == 1) {
	    //, diff, '===', diffs.toString());
	    return false;
	}
	if (diff == 3 && run == 2) {
	    //, diff, '===', diffs.toString());
	    return false;
	}
	if (diff == 3 && run == 3) {
	    //, diff, '===', diffs.toString());
	    return false;
	}

	// skip oddball port jumps due to noise
	if (diff > 8) {
	    //console.log('> 8', diff,'===', diffs.toString());
	    continue;
	}

	diffs.push(diff);
    }

    //console.log('---', diffs.toString());

    var counter = 0;
    while(standardDeviation(diffs) > sigma && counter <= n) {
	//console.log(standardDeviation(diffs));
	var max = d3.max(diffs);
	var splice_idx = diffs.indexOf(max);
	diffs.splice(splice_idx, 1);
	//console.log('std remove', max, counter);
	//if (counter == 10) console.log(diffs);
	//console.log(v, e);
	counter++;
    }
    //console.log('diffs', diffs);

    return mode(diffs);
//    var avg = sum(diffs) / diffs.length;

    // guarantees we see a good match; high diffs of same port length gives validity
//    if (diffs.length > 1) {
//	console.log("heyo", diffs.length, diffs.toString());
	// TODO should retrn the most common #
//	return mode(diffs);
//    } else {
//	return avg;
	//return Math.round(avg);
//    }
}

function mode(array) {
    if(array.length == 0)
        return null;
    var modeMap = {};
    var maxEl = array[0], maxCount = 1;
    for(var i = 0; i < array.length; i++) {
        var el = array[i];
        if(modeMap[el] == null) {
                modeMap[el] = 1;
	} else {
                modeMap[el]++;  
	}
        if(modeMap[el] > maxCount) {
                maxEl = el;
                maxCount = modeMap[el];
        }
    }
    return maxEl;
}

function variance(arr) {
    var len = 0;
    var sum=0;

    for(var i=0;i<arr.length;i++) {
	if (arr[i] == ""){}
	else if (!isNum(arr[i])) {
	    alert(arr[i] + " is not number, Variance Calculation failed!");
	    return 0;
	} else {
	    len = len + 1;
	    sum = sum + parseFloat(arr[i]); 
	}
    }

    var v = 0;
    if (len > 1) {
	var mean = sum / len;
	for(var i=0;i<arr.length;i++) {
	    if (arr[i] == ""){}
	    else {
		v = v + (arr[i] - mean) * (arr[i] - mean);			  
	    }		
	}
	
	return v / len;
    } else {
	return 0;
    }	
}

function sum(arr) {
    var i = arr.length;
    var sum = 0;
    while (i--) {
	sum += arr[i];
    }
    return sum;
}

function mean(arr) {
    var n = arr.length;
    var sum = 0;

    for (var i = 1; i < n; i++) {
	var item = arr[i];
	sum += item;
    }
    var mean = sum / n;
    return mean;
}

function graph(selector, data) {
    //console.log('graphing', data.toString());

    var w = 1000,
    h = 250,
    margin = 20,
    y = d3.scale.linear().domain([0, d3.max(data)]).range([0 + margin, h - margin]),
    x = d3.scale.linear().domain([0, data.length]).range([0 + margin, w - margin]);

    var svg = d3.select(selector)
	.append('svg:svg')
	.attr('width', w)
	.attr('height', h);
    
    var g = svg.append("svg:g")
	.attr("transform", "translate(0, " + h + ")");

    var line = d3.svg.line()
	.x(function(d,i) { return x(i); })
	.y(function(d) { return -1 * y(d); });

    g.append("svg:path").attr("d", line(data));

    // horrible way to build axes
    g.append("svg:line")
	.attr("x1", x(0))
	.attr("y1", -1 * y(0))
	.attr("x2", x(w))
	.attr("y2", -1 * y(0));
    
    g.append("svg:line")
	.attr("x1", x(0))
	.attr("y1", -1 * y(0))
	.attr("x2", x(0))
	.attr("y2", -1 * y(d3.max(data)));

    g.selectAll(".xLabel")
	.data(x.ticks(5))
	.enter().append("svg:text")
	.attr("class", "xLabel")
	.text(String)
	.attr("x", function(d) { return x(d); })
	.attr("y", 0)
	.attr("text-anchor", "middle");
    
    g.selectAll(".yLabel")
	.data(y.ticks(4))
	.enter().append("svg:text")
	.attr("class", "yLabel")
	.text(String)
	.attr("x", 0)
	.attr("y", function(d) { return -1 * y(d); })
	.attr("text-anchor", "right")
	.attr("dy", 4);

    g.selectAll(".xTicks")
	.data(x.ticks(5))
	.enter().append("svg:line")
	.attr("class", "xTicks")
	.attr("x1", function(d) { return x(d); })
	.attr("y1", -1 * y(0))
	.attr("x2", function(d) { return x(d); })
	.attr("y2", -1 * y(-0.3));
    
    g.selectAll(".yTicks")
	.data(y.ticks(4))
	.enter().append("svg:line")
	.attr("class", "yTicks")
	.attr("y1", function(d) { return -1 * y(d); })
	.attr("x1", x(-0.3))
	.attr("y2", function(d) { return -1 * y(d); })
	.attr("x2", x(0));

}

function isNum(args)
{
	args = args.toString();

	if (args.length == 0)
	return false;

	for (var i = 0;  i<args.length;  i++)
	{
		if ((args.substring(i,i+1) < "0" || args.substring(i, i+1) > "9") && args.substring(i, i+1) != "."&& args.substring(i, i+1) != "-")
		{
			return false;
		}
	}

	return true;
}


function standardDeviation(arr) {
    return Math.sqrt(variance(arr));
}

function standardError(arr) {
    return Math.sqrt(variance(arr)/(arr.length-1));
}

function median(arr)
{
	arr.sort(function(a,b){return a-b});
	
	var median = 0;
	
    if (arr.length % 2 == 1)
	{
	    median = arr[(arr.length+1)/2 - 1];
	}
	else
	{
	    median = (1 * arr[arr.length/2 - 1] + 1 * arr[arr.length/2] )/2;
	}
	
	return median
}

