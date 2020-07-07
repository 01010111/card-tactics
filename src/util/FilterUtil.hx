package util;

import openfl.filters.ColorMatrixFilter;

class FilterUtil {
	
	public static var grayscale_filter:ColorMatrixFilter = new ColorMatrixFilter([
		0.25, 0.25, 0.25, 0.00, 0.00, 
		0.25, 0.25, 0.25, 0.00, 0.00, 
		0.25, 0.25, 0.25, 0.00, 0.00, 
		0.00, 0.00, 0.00, 1.00, 1.00,
	]);

}
