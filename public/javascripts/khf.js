function trackLink(link) {
  new Ajax.Request('/track', {
    method: 'post',
    parameters: {LinkClick: link.href}
  });

  if (link.target == '_blank')
    window.open(link.href,'opened_window',
                'width=800,height=600,toolbar=yes,location=yes,' +
                'directories=yes,status=yes,menubar=yes,scrollbars=yes,' +
                'copyhistory=yes,resizable=yes');
  else if (link.target == '_self')
    setTimeout('document.location = "' + link.href + '"', 222);
  else // must be an iframe id
    alert('unimplemented link type.  anchor should specify target.'); //TODO
  return false; // Don't follow the href from the anchor; we already have.
}
