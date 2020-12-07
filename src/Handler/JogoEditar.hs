{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.JogoEditar where
import Import
import Database.Persist.Postgresql

getJogoEditarR :: JogoId -> Handler Html
getJogoEditarR pid = do
    err <- runDB $ get404 pid
    formEditarJogo (JogoEditarR pid) (Just err)

formEditarJogo :: Route App -> Maybe Jogo -> Handler Html
formEditarJogo rt dado = do
    (widget, _) <- generateFormPost (formJogo dado)
    defaultLayout $ do 
        sess <- lookupSession "_NOME"
        addStylesheet (StaticR css_bootstrap_css)
        addStylesheet (StaticR css_style_css)
        $(whamletFile "templates/jogoeditar.hamlet")

formJogo :: Maybe Jogo -> Form Jogo
formJogo jogo = renderBootstrap $ Jogo
   <$> areq textField "Nome: " (fmap jogoNome jogo)
   <*> areq dayField "Lançamento: " (fmap jogoLancamento jogo)
   <*> areq (selectField desenvolvedoras) "Desenvolvedora: " (jogoDesenvolvedora <$> jogo)

desenvolvedoras = do
    rows <- runDB $ selectList [] [Asc DesenvolvedoraNome]
    optionsPairs $
        map (\r -> (desenvolvedoraNome $ entityVal r, entityKey r)) rows

postJogoEditarR :: JogoId -> Handler Html
postJogoEditarR pid = do
    ((res, _), _) <- runFormPost (formJogo Nothing)
    case res of
        FormSuccess desenv -> do
            _ <- runDB (replace pid desenv)
            redirect JogosR
        _ -> redirect HomeR