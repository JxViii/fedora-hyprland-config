// NAME: Mosaic Images
// AUTHORS: OhItsTom (modified)
// DESCRIPTION: Convert images into a mosaic tile effect.
(function mosaicImages() {
	const svgNS = "http://www.w3.org/2000/svg";

	const filterElement = document.createElementNS(svgNS, "filter");
	filterElement.setAttribute("id", "mosaic");
	filterElement.setAttribute("x", "0%");
	filterElement.setAttribute("y", "0%");
	filterElement.setAttribute("width", "100%");
	filterElement.setAttribute("height", "100%");
	filterElement.setAttribute("color-interpolation-filters", "sRGB");

	filterElement.innerHTML = `
		<feFlood x="0" y="0" height="1" width="1" />
		<feComposite width="5" height="5" />
		<feTile result="a" />
		<feComposite in="SourceGraphic" in2="a" operator="in" />
		<feMorphology operator="dilate" radius="1" />
		<feComponentTransfer>
			<feFuncR type="discrete" tableValues="0 0.25 0.5 0.75 1" />
			<feFuncG type="discrete" tableValues="0 0.25 0.5 0.75 1" />
			<feFuncB type="discrete" tableValues="0 0.25 0.5 0.75 1" />
		</feComponentTransfer>
	`;

	const svgElement = document.createElementNS(svgNS, "svg");
	svgElement.setAttribute("style", "height: 0; position: absolute;");
	svgElement.appendChild(filterElement);
	document.body.appendChild(svgElement);

	const cssStyleElement = document.createElement("style");
	cssStyleElement.textContent = `img { filter: url('#mosaic') saturate(1.4) contrast(1.1) grayscale(.7); }`;
	document.head.appendChild(cssStyleElement);
})();