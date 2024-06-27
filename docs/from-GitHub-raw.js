function main() {
	const params = new URLSearchParams(location.search)
	if (!params.has('url')) { return }

	/** @type {?URL} */
	const url = URL.parse(params.get('url'))
	if (!url) {
		console.error('not a URL: %s', params.get('url'))
		return
	}
	if (url.origin !== 'https://raw.githubusercontent.com') {
		console.error('unsupported origin: %s', url.origin)
		return
	}

	const match = url.pathname.match('(/[^/]+/[^/]+)/(.+)')
	if (!match) {
		console.error('bad path: %s', url.pathname)
		return
	}

	const [_, head, tail] = match
	url.pathname = `${head}/blob/${tail}`
	url.host = 'github.com'
	location = url
}
main()
