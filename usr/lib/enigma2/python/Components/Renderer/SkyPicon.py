from Renderer import Renderer
from enigma import ePixmap
from enigma import iServiceInformation, iPlayableService, iPlayableServicePtr
from Tools.Directories import fileExists, SCOPE_SKIN_IMAGE, SCOPE_CURRENT_SKIN, resolveFilename

# For SNP
from ServiceReference import ServiceReference
import re, unicodedata

class SkyPicon(Renderer):
	searchPaths = ('/usr/share/enigma2/SkyQ/%s/','/media/usb/SkyQ/%s/','/usr/SkyQ/%s/','/media/hdd/SkyQ/%s/','/media/hdd/SkyQ/%s/')

	def __init__(self):
		Renderer.__init__(self)
		self.path = "picon"
		self.nameCache = { }
		self.pngname = ""

	def applySkin(self, desktop, parent):
		attribs = [ ]
		for (attrib, value) in self.skinAttributes:
			if attrib == "path":
				self.path = value
			else:
				attribs.append((attrib,value))
		self.skinAttributes = attribs
		return Renderer.applySkin(self, desktop, parent)

	GUI_WIDGET = ePixmap

	def changed(self, what):
		if self.instance:
			pngname = ""
			if what[0] != self.CHANGED_CLEAR:
				sname = self.source.text
				pos = sname.rfind(':')
				if pos != -1:
					sname = sname[:pos].rstrip(':').replace(':','_')
					sname = sname.split("_http")[0]
				pngname = self.nameCache.get(sname, "")
				if pngname == "":
					pngname = self.findPicon(sname)
					if pngname == "":
						fields = sname.split('_', 3)
						if len(fields) > 2 and fields[2] != '2': #fallback to 1 for tv services with nonstandard servicetypes
							fields[2] = '1'
						if fields[0] == '4097': #fallback to 1 for IPTV streams
							fields[0] = '1'
						pngname = self.findPicon('_'.join(fields))
					if not pngname: # picon by channel name
						name = ServiceReference(self.source.text).getServiceName()
						name = unicodedata.normalize('NFKD', unicode(name, 'utf_8', errors='ignore')).encode('ASCII', 'ignore')
						name = re.sub('[^a-z0-9]', '', name.replace('&', 'and').replace('+', 'plus').replace('*', 'star').lower())
						if len(name) > 0:
							pngname = self.findPicon(name)
							if not pngname and len(name) > 2 and name.endswith('hd'):
								pngname = self.findPicon(name[:-2])					
					if pngname != "":
						self.nameCache[sname] = pngname
			if pngname == "": # no picon for service found
				pngname = self.nameCache.get("default", "")
				if pngname == "": # no default yet in cache..
					pngname = self.findPicon("sky_default")
					if pngname == "":
						tmp = resolveFilename(SCOPE_CURRENT_SKIN, "sky_default.png")
						if fileExists(tmp):
							pngname = tmp
						else:
							pngname = resolveFilename(SCOPE_SKIN_IMAGE, "skin_default/sky_default.png")
					self.nameCache["default"] = pngname
			if self.pngname != pngname:
				self.instance.setScale(1)
				self.instance.setPixmapFromFile(pngname)
				self.pngname = pngname

	def findPicon(self, serviceName):
		for path in self.searchPaths:
			pngname = (path % self.path) + serviceName + ".png"
			if fileExists(pngname):
				return pngname
		return ""