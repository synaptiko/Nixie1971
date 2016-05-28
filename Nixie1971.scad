thickness = 1.5;
contactShaftOffset = 15;
BasementPart(contactShaftPadding=thickness, contactShaftOffset=contactShaftOffset);
translate([11, 3, 43.4 + contactShaftOffset]) NixiePart(thickness=thickness);

module BasementPart(width=106, height=3, depth=78, padding=0.5, contactShaft=[83, 11.5], contactShaftPadding, contactShaftOffset) {
	legDistance = 50;
	legLength = 9.5;
	legDiameter = 8;
	legHoleDiameter = 5.75;
	legScrewHoleDiameter = 3;
	holeEdgeDistance = 3;

	difference() {
		union() {
			difference() {
				BasementDesk(width=width, height=height, depth=depth, padding=padding, hole=8, holeEdgeDistance=holeEdgeDistance);
				ContactShaft(width, height, depth, padding, contactShaft, contactShaftPadding, contactShaftOffset);
			}
			BasementAttachmentLegs(distance=legDistance, mainDiameter=legDiameter, diameter=legDiameter, length=legLength, width=width, depth=depth, padding=padding, holeEdgeDistance=holeEdgeDistance);
		}
		translate([0, height, 0]) BasementAttachmentLegs(distance=legDistance, mainDiameter=legDiameter, diameter=legHoleDiameter, length=legLength, width=width, depth=depth, padding=padding, holeEdgeDistance=holeEdgeDistance);
		translate([0, -(legLength - height), 0]) BasementAttachmentLegs(distance=legDistance, mainDiameter=legDiameter, diameter=legScrewHoleDiameter, length=(height * 2), width=width, depth=depth, padding=padding, holeEdgeDistance=holeEdgeDistance);
	}
}

module BasementAttachmentLegs(distance, mainDiameter, diameter, length, width, depth, padding, holeEdgeDistance, $fn=100) {
	width = (width - padding * 2);
	depth = (depth - padding * 2);
	rotate(a=[90,0,0]) {
		translate([width / 2 - distance / 2, 0, 0]) {
			translate([0, depth - (diameter / 2 + (mainDiameter - diameter) / 2) - holeEdgeDistance, 0]) {
				cylinder(d=diameter, h=length);
				translate([distance, 0]) cylinder(d=diameter, h=length);
			}
			translate([0, (diameter / 2) + holeEdgeDistance + (mainDiameter - diameter) / 2, 0]) {
				cylinder(d=diameter, h=length);
				translate([distance, 0]) cylinder(d=diameter, h=length);
			}
		}
	}
}

module ContactShaft(width, height, depth, padding, contactShaft, contactShaftPadding, contactShaftOffset) {
	translate([((width - padding * 2) / 2 - contactShaft[0] / 2) + contactShaftPadding, -height * 0.5, contactShaftPadding + contactShaftOffset]) cube([contactShaft[0] - contactShaftPadding * 2, height * 2, contactShaft[1] - contactShaftPadding * 2]);
}

module BasementDesk(width, height, depth, hole, holeEdgeDistance, padding, $fn=100) {
	holeEdgeDistance = (holeEdgeDistance + hole / 2 - padding);
	width = (width - padding * 2);
	depth = (depth - padding * 2);
	difference() {
		cube([width, height, depth]);
		rotate(a=[90,0,0]) {
			translate([holeEdgeDistance, holeEdgeDistance, -height * 1.5]) cylinder(d=hole, h=(height * 2));
			translate([width - holeEdgeDistance, holeEdgeDistance, -height * 1.5]) cylinder(d=hole, h=(height * 2));
			translate([holeEdgeDistance, depth - holeEdgeDistance, -height * 1.5]) cylinder(d=hole, h=(height * 2));
			translate([width - holeEdgeDistance, depth - holeEdgeDistance, -height * 1.5]) cylinder(d=hole, h=(height * 2));
		}
	}
}

module NixiePart(nixiesTubeLength=33.4, nixieDiameter=20, depths=[3.5, 12, 22], holes=[4, 18.5, 11], sideABRatio=0.2, thickness) {
	paddings = [thickness, thickness, 0.5, thickness]; // top, right, bottom, left
	width = ((nixieDiameter * 4) + paddings[1] + paddings[3]);
	height = (nixieDiameter + paddings[0] + paddings[2]);
	radius = (nixieDiameter / 2 + paddings[0]);
	translate([0, 0, 0]) TopNixieHandle(width=width, height=height, depth=depths[0], radius=radius, paddings=paddings, nixieDiameter=nixieDiameter, hole=holes[0]);
	difference() {
		translate([0, 0, -(nixiesTubeLength)]) BottomNixieHandle(width=width, height=height, depth=depths[1], radius=radius, paddings=paddings, nixieDiameter=nixieDiameter, holeSideA=holes[1], holeSideB=holes[2], sideABRatio=sideABRatio);
		translate([0, 0, -(nixiesTubeLength + (depths[2] - depths[1]))]) NixieContactsCover(width=width, height=height, depth=depths[2], radius=radius, thickness=thickness);
	}
	translate([0, 0, -(nixiesTubeLength + (depths[2] - depths[1]))]) NixieContactsCover(width=width, height=height, depth=depths[2], radius=radius, thickness=thickness);
}

module NixieContactsCover(width, height, depth, radius, thickness, $fn=100) {
	difference() {
		NixieHandleBase(width=width, height=height, depth=depth, radius=radius);
		translate([thickness, 0, thickness]) NixieHandleBase(width=(width - thickness * 2), height=(height - thickness), depth=(depth - thickness), radius=(radius - thickness));
	}
}

module BottomNixieHandle(width, height, depth, radius, paddings, nixieDiameter, holeSideA, holeSideB, sideABRatio, $fn=100) {
	difference() {
		NixieHandleBase(width=width, height=height, depth=depth, radius=radius);
		translate([(width / 2), height - (nixieDiameter / 2) - paddings[0]]) {
			for (i = [-2:1]) {
				translate([(nixieDiameter / 2) + i * nixieDiameter, 0, depth * sideABRatio]) cylinder(d=holeSideA, h=(depth * (1 - sideABRatio)));
				translate([(nixieDiameter / 2) + i * nixieDiameter, 0]) cylinder(d=holeSideB, h=(depth * sideABRatio));
			}
		}
	}
}

module TopNixieHandle(width, height, depth, radius, paddings, nixieDiameter, hole, $fn=100) {
	difference() {
		NixieHandleBase(width=width, height=height, depth=depth, radius=radius);
		translate([(width / 2), height - (nixieDiameter / 2) - paddings[0]]) {
			for (i = [-2:1]) {
				translate([(nixieDiameter / 2) + i * nixieDiameter, 0]) cylinder(d=hole, h=depth);
			}
		}
	}
}

module NixieHandleBase(width, height, depth, radius, $fn=100) {
	intersection() {
		translate([0, height - radius]) cube([radius, radius, depth]);
		translate([radius, height - radius]) cylinder(r=radius, h=depth);
	}
	intersection() {
		translate([width - radius, height - radius]) cube([radius, radius, depth]);
		translate([width - radius, height - radius]) cylinder(r=radius, h=depth);
	}
	cube([width, height - radius, depth]);
	translate([radius, height - radius]) cube([width - radius * 2, radius, depth]);
}
