-- ============================================================
-- 特寶寶旅遊助手 RLS Policies（自動產生，請勿手動編輯）
-- 更新時間：2026-05-26T04:56:51.491Z
-- ============================================================

-- attractions
CREATE POLICY "attr_delete"
  ON attractions
  AS PERMISSIVE
  FOR DELETE
  TO {public}
  USING (can_edit_trip(trip_id))
;

CREATE POLICY "attr_insert"
  ON attractions
  AS PERMISSIVE
  FOR INSERT
  TO {public}
  WITH CHECK (can_edit_trip(trip_id))
;

CREATE POLICY "attr_select"
  ON attractions
  AS PERMISSIVE
  FOR SELECT
  TO {public}
  USING (has_trip_access(trip_id))
;

CREATE POLICY "attr_update"
  ON attractions
  AS PERMISSIVE
  FOR UPDATE
  TO {public}
  USING (can_edit_trip(trip_id))
;

-- currencies
CREATE POLICY "curr_delete"
  ON currencies
  AS PERMISSIVE
  FOR DELETE
  TO {public}
  USING (can_edit_trip(trip_id))
;

CREATE POLICY "curr_insert"
  ON currencies
  AS PERMISSIVE
  FOR INSERT
  TO {public}
  WITH CHECK (can_edit_trip(trip_id))
;

CREATE POLICY "curr_select"
  ON currencies
  AS PERMISSIVE
  FOR SELECT
  TO {public}
  USING (has_trip_access(trip_id))
;

CREATE POLICY "curr_update"
  ON currencies
  AS PERMISSIVE
  FOR UPDATE
  TO {public}
  USING (can_edit_trip(trip_id))
;

-- expenses
CREATE POLICY "exp_delete"
  ON expenses
  AS PERMISSIVE
  FOR DELETE
  TO {public}
  USING (can_edit_trip(trip_id))
;

CREATE POLICY "exp_insert"
  ON expenses
  AS PERMISSIVE
  FOR INSERT
  TO {public}
  WITH CHECK (can_edit_trip(trip_id))
;

CREATE POLICY "exp_select"
  ON expenses
  AS PERMISSIVE
  FOR SELECT
  TO {public}
  USING (has_trip_access(trip_id))
;

CREATE POLICY "exp_update"
  ON expenses
  AS PERMISSIVE
  FOR UPDATE
  TO {public}
  USING (can_edit_trip(trip_id))
;

-- packing_items
CREATE POLICY "pack_delete"
  ON packing_items
  AS PERMISSIVE
  FOR DELETE
  TO {public}
  USING (can_edit_trip(trip_id))
;

CREATE POLICY "pack_insert"
  ON packing_items
  AS PERMISSIVE
  FOR INSERT
  TO {public}
  WITH CHECK (can_edit_trip(trip_id))
;

CREATE POLICY "pack_select"
  ON packing_items
  AS PERMISSIVE
  FOR SELECT
  TO {public}
  USING (has_trip_access(trip_id))
;

CREATE POLICY "pack_update"
  ON packing_items
  AS PERMISSIVE
  FOR UPDATE
  TO {public}
  USING (can_edit_trip(trip_id))
;

-- profiles
CREATE POLICY "profiles_insert"
  ON profiles
  AS PERMISSIVE
  FOR INSERT
  TO {public}
  WITH CHECK ((auth.uid() = id))
;

CREATE POLICY "profiles_select"
  ON profiles
  AS PERMISSIVE
  FOR SELECT
  TO {public}
  USING (true)
;

CREATE POLICY "profiles_update"
  ON profiles
  AS PERMISSIVE
  FOR UPDATE
  TO {public}
  USING ((auth.uid() = id))
  WITH CHECK ((auth.uid() = id))
;

-- restaurants
CREATE POLICY "rest_delete"
  ON restaurants
  AS PERMISSIVE
  FOR DELETE
  TO {public}
  USING (can_edit_trip(trip_id))
;

CREATE POLICY "rest_insert"
  ON restaurants
  AS PERMISSIVE
  FOR INSERT
  TO {public}
  WITH CHECK (can_edit_trip(trip_id))
;

CREATE POLICY "rest_select"
  ON restaurants
  AS PERMISSIVE
  FOR SELECT
  TO {public}
  USING (has_trip_access(trip_id))
;

CREATE POLICY "rest_update"
  ON restaurants
  AS PERMISSIVE
  FOR UPDATE
  TO {public}
  USING (can_edit_trip(trip_id))
;

-- schedule_items
CREATE POLICY "si_delete"
  ON schedule_items
  AS PERMISSIVE
  FOR DELETE
  TO {public}
  USING (can_edit_trip(trip_id))
;

CREATE POLICY "si_insert"
  ON schedule_items
  AS PERMISSIVE
  FOR INSERT
  TO {public}
  WITH CHECK (can_edit_trip(trip_id))
;

CREATE POLICY "si_select"
  ON schedule_items
  AS PERMISSIVE
  FOR SELECT
  TO {public}
  USING (has_trip_access(trip_id))
;

CREATE POLICY "si_update"
  ON schedule_items
  AS PERMISSIVE
  FOR UPDATE
  TO {public}
  USING (can_edit_trip(trip_id))
;

-- stays
CREATE POLICY "stays_delete"
  ON stays
  AS PERMISSIVE
  FOR DELETE
  TO {public}
  USING (can_edit_trip(trip_id))
;

CREATE POLICY "stays_insert"
  ON stays
  AS PERMISSIVE
  FOR INSERT
  TO {public}
  WITH CHECK (can_edit_trip(trip_id))
;

CREATE POLICY "stays_select"
  ON stays
  AS PERMISSIVE
  FOR SELECT
  TO {public}
  USING (has_trip_access(trip_id))
;

CREATE POLICY "stays_update"
  ON stays
  AS PERMISSIVE
  FOR UPDATE
  TO {public}
  USING (can_edit_trip(trip_id))
;

-- transport_details
CREATE POLICY "td_delete"
  ON transport_details
  AS PERMISSIVE
  FOR DELETE
  TO {public}
  USING (can_edit_trip(( SELECT transport_groups.trip_id
   FROM transport_groups
  WHERE (transport_groups.id = transport_details.group_id))))
;

CREATE POLICY "td_insert"
  ON transport_details
  AS PERMISSIVE
  FOR INSERT
  TO {public}
  WITH CHECK (can_edit_trip(( SELECT transport_groups.trip_id
   FROM transport_groups
  WHERE (transport_groups.id = transport_details.group_id))))
;

CREATE POLICY "td_select"
  ON transport_details
  AS PERMISSIVE
  FOR SELECT
  TO {public}
  USING (has_trip_access(( SELECT transport_groups.trip_id
   FROM transport_groups
  WHERE (transport_groups.id = transport_details.group_id))))
;

CREATE POLICY "td_update"
  ON transport_details
  AS PERMISSIVE
  FOR UPDATE
  TO {public}
  USING (can_edit_trip(( SELECT transport_groups.trip_id
   FROM transport_groups
  WHERE (transport_groups.id = transport_details.group_id))))
;

-- transport_groups
CREATE POLICY "tg_delete"
  ON transport_groups
  AS PERMISSIVE
  FOR DELETE
  TO {public}
  USING (can_edit_trip(trip_id))
;

CREATE POLICY "tg_insert"
  ON transport_groups
  AS PERMISSIVE
  FOR INSERT
  TO {public}
  WITH CHECK (can_edit_trip(trip_id))
;

CREATE POLICY "tg_select"
  ON transport_groups
  AS PERMISSIVE
  FOR SELECT
  TO {public}
  USING (has_trip_access(trip_id))
;

CREATE POLICY "tg_update"
  ON transport_groups
  AS PERMISSIVE
  FOR UPDATE
  TO {public}
  USING (can_edit_trip(trip_id))
;

-- trip_collaborators
CREATE POLICY "collaborators_delete"
  ON trip_collaborators
  AS PERMISSIVE
  FOR DELETE
  TO {public}
  USING (((auth.uid() = user_id) OR (EXISTS ( SELECT 1
   FROM trips
  WHERE ((trips.id = trip_collaborators.trip_id) AND (trips.owner_id = auth.uid()))))))
;

CREATE POLICY "collaborators_insert"
  ON trip_collaborators
  AS PERMISSIVE
  FOR INSERT
  TO {public}
  WITH CHECK ((EXISTS ( SELECT 1
   FROM trips
  WHERE ((trips.id = trip_collaborators.trip_id) AND (trips.owner_id = auth.uid())))))
;

CREATE POLICY "collaborators_select"
  ON trip_collaborators
  AS PERMISSIVE
  FOR SELECT
  TO {public}
  USING (((auth.uid() = user_id) OR (EXISTS ( SELECT 1
   FROM trips
  WHERE ((trips.id = trip_collaborators.trip_id) AND (trips.owner_id = auth.uid()))))))
;

-- trip_day_photos
CREATE POLICY "photos_delete"
  ON trip_day_photos
  AS PERMISSIVE
  FOR DELETE
  TO {public}
  USING (can_edit_trip(trip_id))
;

CREATE POLICY "photos_insert"
  ON trip_day_photos
  AS PERMISSIVE
  FOR INSERT
  TO {public}
  WITH CHECK (can_edit_trip(trip_id))
;

CREATE POLICY "photos_select"
  ON trip_day_photos
  AS PERMISSIVE
  FOR SELECT
  TO {public}
  USING (has_trip_access(trip_id))
;

CREATE POLICY "photos_update"
  ON trip_day_photos
  AS PERMISSIVE
  FOR UPDATE
  TO {public}
  USING (can_edit_trip(trip_id))
;

-- trips
CREATE POLICY "trips_delete"
  ON trips
  AS PERMISSIVE
  FOR DELETE
  TO {public}
  USING ((auth.uid() = owner_id))
;

CREATE POLICY "trips_insert"
  ON trips
  AS PERMISSIVE
  FOR INSERT
  TO {public}
  WITH CHECK ((auth.uid() = owner_id))
;

CREATE POLICY "trips_select"
  ON trips
  AS PERMISSIVE
  FOR SELECT
  TO {public}
  USING (has_trip_access(id))
;

CREATE POLICY "trips_update"
  ON trips
  AS PERMISSIVE
  FOR UPDATE
  TO {public}
  USING (((auth.uid() = owner_id) OR (EXISTS ( SELECT 1
   FROM trip_collaborators
  WHERE ((trip_collaborators.trip_id = trips.id) AND (trip_collaborators.user_id = auth.uid()) AND (trip_collaborators.role = 'editor'::text))))))
;

