--
-- Daten für Tabelle `help_messages`
--

UPDATE `info` SET `value_name` = '3.3' WHERE  `info`.`key_name` = 'version';

-- New stuff for InGrid 3.3
-- ========================

INSERT INTO `help_messages` (`id`, `version`, `gui_id`, `entity_class`, `language`, `name`, `help_text`, `sample`) VALUES
(1396, 0, 5100, -1, 'de', 'Vorschaugrafik', 'Hier kann eine URL auf ein Bild eingetragen werden, welches im Portal in den Suchergebnissen angezeigt werden soll.', ''),
(1397, 0, 5100, -1, 'en', 'Preview image', 'You can add an url to an image, which shall be shown within the search results in the portal.', ''),
(1398, 0, 7103, -1, 'de', 'Zusatzinformation', 'Angabe von zusätzlichen Informationen wie zum Beispiel die Veröffentlichungsbreite.', ''),
(1399, 0, 7103, -1, 'en', 'Preview image', 'Add additional information as for example the publication condition.', ''),
(1400, 0, 4571, -1, 'de', 'Veröffentlichung', 'Das Feld Veröffentlichung gibt an, welche Veröffentlichungsmöglichkeiten für die Adresse freigegeben sind. Die Liste der Möglichkeiten ist nach Freigabestufen hierarchisch geordnet. Wird einer Adresse eine niedrigere Freigabestufe zugeordnet (z.B. von Internet auf Intranet), werden automatisch auch alle untergeordneten Adressen dieser Stufe zugeordnet. Soll einer Adresse eine höhere Freigabestufe zugeordnet werden als die der übergeordneten Adresse, wird die Zuordnung verweigert. Wird einer Adresse eine höhere Freigabestufe zugeordnet (z.B. von Amtsintern auf Intranet), kann auch allen untergeordneten Adressen die höhere Freigabestufe zugeordnet werden. Beim Veröffentlichen wird zusätzlich überprüft, ob die Veröffentlichungsbreite von verweisenden Objekten, mit der der Adresse gültig ist.', 'Die Einstellung haben folgende Bedeutung: Internet: Die Adresse darf überall veröffentlicht werden; Intranet: Die Adresse darf nur im Intranet veröffentlicht werden, aber nicht im Internet; Amtsintern: Die Adresse darf nur in der erfassenden Instanz aber weder im Internet noch im Intranet veröffentlicht werden.'),
(1401, 0, 4571, -1, 'en', 'Publication condition', 'The publication field details which publication possibilities have been allowed for the address. The list of the possibilities has been ordered hierarchically according to release levels. If a lower release level has been dedicated to an address (e.g. from internet to intranet), all the addresses subordinate to this will be automatically dedicated to this level. If a higher release level is dedicated to an address than the one dedicated to the subordinate address then the action is rejected. If a higher release level is dedicated to an address (e.g. in-house on intranet), then all the subordinate addresses will also be dedicated to the higher release level. During publication it is also checked if the publication condition of linked objects are valid with the one from the address.', 'The setting has the following significance: Internet: the address may be published everywhere; Intranet: the address may only be published in the intranet but not in the internet; In-house: the address may only be published as it is created but neither in the internet nor in the intranet.');
