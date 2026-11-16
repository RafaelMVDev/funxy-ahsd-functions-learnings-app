INSERT INTO Itens (id_item, tipo, estilo, descricao, meta_dados) VALUES
                                                                     (-7161, 'loja', 'avatar', 'Raposa Cartesiana',
                                                                      '{"slug":"raposa-cartesiana","animacao":"idle"}'),
                                                                     (-7162, 'passe', 'moldura', 'Moldura da Parábola',
                                                                      '{"slug":"moldura-parabola","cor":"#EE9248"}');

// Loja e passe de batalha

INSERT INTO Item_Loja (id_item, valor)
VALUES (-7161, 30);

INSERT INTO Item_Passe_Batalha (id_item, xp_necessario)
VALUES (-7162, 100);