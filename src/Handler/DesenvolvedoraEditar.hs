{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.DesenvolvedoraEditar where
import Import
import Database.Persist.Postgresql

getDesenvolvedoraEditarR :: DesenvolvedoraId -> Handler Html
getDesenvolvedoraEditarR pid = do
    err <- runDB $ get404 pid
    formEditarDesenvolvedora (DesenvolvedoraEditarR pid) (Just err)

formEditarDesenvolvedora :: Route App -> Maybe Desenvolvedora -> Handler Html
formEditarDesenvolvedora rt dado = do
    (widget, _) <- generateFormPost (formDesenvolvedora dado)
    defaultLayout $ do 
        $(whamletFile "templates/desenvolvedoraeditar.hamlet")

formDesenvolvedora :: Maybe Desenvolvedora -> Form Desenvolvedora
formDesenvolvedora desenvolvedora = renderBootstrap $ Desenvolvedora
   <$> areq textField "Nome: " (fmap desenvolvedoraNome desenvolvedora)

postDesenvolvedoraEditarR :: DesenvolvedoraId -> Handler Html
postDesenvolvedoraEditarR pid = do
    ((res, _), _) <- runFormPost (formDesenvolvedora Nothing)
    case res of
        FormSuccess desenv -> do
            _ <- runDB (replace pid desenv)
            redirect DesenvolvedorasR
        _ -> redirect HomeR