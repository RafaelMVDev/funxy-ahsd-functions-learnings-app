# Funxy — refatoração visual

## Abrir
Extraia o ZIP e importe `fun-xy/project.godot`. A configuração original indica Godot **4.7**; ela foi mantida. A versão “7.2” informada não coincide com o arquivo enviado.
A pasta `.godot` não acompanha esta entrega: o editor regenera o cache ao importar. O backend e os demais arquivos de origem foram preservados.

## Mudanças
- Tema local `ui/funxy_theme.tres`, aplicado por cena para não afetar a partida.
- Fundos claros, superfícies brancas, texto escuro e ações em azul. Verde suave, dourado e coral diferenciam destaques sem sobrecarregar as telas.
- Ícones SVG integrados para navegação, avatar padrão e indicadores; navegação com ícones de 24×24 e legendas de tamanho consistente.
- Navegação inferior com largura adaptável e indicação visual da tela atual.
- Trilhas: área de rolagem ocupa o espaço disponível acima da navegação; título e barra de progresso mais legíveis.
- Conteúdos e perfil: painéis e tipografia alinhados ao tema.
- Ranking: título, cartão do jogador e lista separados; linhas com espaçamento, cantos suaves e nomes longos abreviados visualmente. Ordenação e dados preservados.
- Configurações: cabeçalho, identificação e opções organizados em uma área rolável. As conexões dos nós reposicionados foram atualizadas.
- Leitura: fundo de papel claro, texto escuro, margens e entrelinhas; controles existentes mantidos no rodapé.
- Acesso: ajustes discretos na cena unificada de login/cadastro, campos maiores e elementos decorativos menos intensos. Animação e autenticação preservadas.
- Menu inicial e verificação: aplicação do tema, sem alterações nas ações. Cena de resultado restaurada ao original.
- Corrigido marcador de merge no estilo de `cenas_Luis/Trilha1.tscn`.

## Scripts
Scripts existentes modificados: `ranking.gd` e `BotaoFase.gd`: aparência de elementos criados em tempo de execução, tratamento visual de nomes longos e dicas dos estados das fases. A definição de disponibilidade, conclusão e retomada não mudou.
O limite de tamanho da foto gerada no ranking foi substituído por alinhamento e tamanho mínimo, mantendo sua função visual e evitando depender de `custom_maximum_size` no script.

## Preservação
Comparação por bytes confirmou que as cenas da partida, seus scripts matemáticos, `project.godot` e os AutoLoads de API, sessão e catálogo permanecem iguais aos arquivos originais.
Nenhum endpoint, dado de API, recompensa, cálculo, colisão, desbloqueio ou conteúdo didático foi criado ou alterado.
Não foram implementados recursos que só aparecem na documentação. A documentação foi consultada como referência de objetivo e limitações do aplicativo.

## Validação realizada
- Importação de recursos na Godot 4.6.3 disponível neste ambiente.
- Carregamento e execução de `_ready` das cenas Trilha, Conteudos, Perfil, Ranking, Configuracoes, cadastro_login e materiais_leitura_interface sem erros no teste final.
- Ranking gerado com 15 linhas no teste local.
- Layouts calculados em 360×640 e 412×915, com teste adicional em 320×568. Mantida a resolução lógica original de 360×640; algumas cenas originais ainda têm dimensões mínimas que excedem 320 pixels lógicos.
- Referências de SubResource e caminhos das conexões conferidos nas cenas alteradas.
- Dados sintéticos usados apenas pelo programa temporário de teste, fora do projeto entregue. Nenhum mock substituiu os dados da API.

## Limitações e pendências originais
- Não houve inspeção visual por captura renderizada: o ambiente não disponibilizou uma janela gráfica utilizável. A validação de layout foi estrutural/headless, não uma avaliação visual final.
- Não houve teste em aparelho Android, Godot 4.7 ou integração completa com o backend. Validar esses ambientes antes da entrega final do aplicativo.
- A cena antiga `login.tscn` referencia `login.gd`, ausente no ZIP original. Essa cena foi preservada sem alterações. A cena inicial configurada é `cadastro_login.tscn`, que passou no teste local.
- Há referências antigas a cenas ausentes em scripts de navegação, como `cadastro.tscn` e variantes de Conteudos dentro de `cenas_Luis`. Não foram redirecionadas por suposição.
- Configurações mantêm o comportamento original, incluindo persistência local da foto e opções sem implementação completa. Esta entrega não adiciona persistência ou novas ações.
- Telas antigas/duplicadas fora do fluxo principal não foram redesenhadas; houve apenas a correção do conflito visual mencionado.

## Arquivos alterados
- `fun-xy/BotaoFase.gd`
- `fun-xy/cadastro_login.tscn`
- `fun-xy/cenas_Luis/Trilha1.tscn`
- `fun-xy/Configuracoes.tscn`
- `fun-xy/Conteudos.tscn`
- `fun-xy/materiais_leitura_interface.tscn`
- `fun-xy/menu_principal.tscn`
- `fun-xy/Perfil.tscn`
- `fun-xy/ranking.gd`
- `fun-xy/Ranking.tscn`
- `fun-xy/Trilha.tscn`
- `fun-xy/verificar_email.tscn`

## Recursos adicionados
- `fun-xy/ui/funxy_theme.tres`
- `fun-xy/ui/home.svg`
- `fun-xy/ui/book.svg`
- `fun-xy/ui/rank.svg`
- `fun-xy/ui/profile.svg`
- `fun-xy/ui/settings.svg`

## Rodapé compartilhado nesta revisão
`ui/rodape.tscn` substitui as barras divergentes de Trilhas, Conteúdos, Perfil, Ranking e Configurações. Mantém as funções de navegação existentes, conectadas aos sinais da instância. `ui/rodape.gd` acrescenta `_ready` e `_emitir_aba`, comentadas como criadas nesta refatoração; elas apenas aplicam o estado visual e encaminham cliques. Os SVGs de navegação têm o mesmo viewBox, espessura de traço e tamanho de exibição.
