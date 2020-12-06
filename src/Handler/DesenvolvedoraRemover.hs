{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.DesenvolvedoraRemover where
import Import
import Database.Persist.Postgresql

postDesenvolvedoraRemoverR :: DesenvolvedoraId -> Handler Html
postDesenvolvedoraRemoverR pid = do
    runDB $ delete pid
    redirect DesenvolvedorasR